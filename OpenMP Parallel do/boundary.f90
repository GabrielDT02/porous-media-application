subroutine bcUV(um,vm)
    use comum
    use omp_lib
    implicit none
    integer :: i, j
    real(8), DIMENSION(1:imax+1,1:jmax  ) :: um
    real(8), DIMENSION(1:imax  ,1:jmax+1) :: vm
       
!------ contorno inferior -----------
    ! $omp parallel do simd private (i)
    DO i=1,imax
        !vm(i,2) = 2.d0*vm(i,4) - vm(i,3)  !!!DARCY
        !vm(i,1) = 2.d0*vm(i,3) - vm(i,2)   !!!DARCY
        !vm(i,2) = 2.d0*1.d0 - vm(i,3)
        !vm(i,1) = 2.d0*1.d0 - vm(i,2)
        vm(i,2) = v_i
    ENDDO
    ! $omp end parallel do

    ! $omp parallel do simd private (i)
    DO i=1,imax 
        vm(i,1) = v_i
    ENDDO
    ! $omp end parallel do

    ! $omp parallel do simd private (i)
    DO i=2,imax
       ! um(i,1) = um(i,2)!!!DARCY
        um(i,1) = 0.d0    !!!DARCY
    ENDDO
    ! $omp end parallel do

    
!------ contorno superior ----------
    ! $omp parallel do simd private (i)
    DO i=2,imax
        vm(i,jmax  ) = 2.d0*vm(i,jmax-2) - vm(i,jmax-1)
    ENDDO
    ! $omp end parallel do
    ! $omp parallel do simd private (i)
    DO i=2,imax
        vm(i,jmax+1) = 2.d0*vm(i,jmax-1) - vm(i,jmax)
    ENDDO
    ! $omp end parallel do

    ! $omp parallel do simd private(i)
    DO i=2,imax
        um(i,jmax) = um(i,jmax-1) 
    ENDDO
    ! $omp end parallel do   
   

 !------ contorno esquerdo --------
    ! $omp parallel do simd private (j)
    DO j=1,jmax
        !um(2,j) = 0.d0 !symmetry
        !um(1,j) = 0.d0 !symmetry
        um(2,j) = 2.d0*um(4  ,j) - um(3,j)  !Darcy
    ENDDO
    ! $omp end parallel do
    ! $omp parallel do simd private (j)
    DO j=1,jmax
        um(1,j) = 2.d0*um(3  ,j) - um(2,j) !Darcy
      !    um(2,j) = 0.d0
      !  um(1,j) = 0.d0
    ENDDO
    ! $omp end parallel do

    ! $omp parallel do simd private(j)
    DO j=1,jmax+1
        vm(1,j) = vm(2,j) !darcy
    ENDDO
    ! $omp end parallel do

!------ contorno direito --------
    ! $omp parallel do simd private(j)
    DO j=1,jmax
        um(imax  ,j) = 2.d0*um(imax-2  ,j) - um(imax-1,j)
    ENDDO
    ! $omp end parallel do
    
    ! $omp parallel do simd private(j)
    DO j=1,jmax
        um(imax+1,j) = 2.d0*um(imax-1  ,j) - um(imax,j)
    ENDDO
    ! $omp end parallel do

    ! $omp parallel do simd private(j)
    DO j=2,jmax
        vm(imax,j) =  vm(imax-1,j) !Darcy
    ENDDO            
    ! $omp end parallel do

!!!----- superficie do cilindro ------
   !     do i=1,imax
  !      do j=1,jmax
 !           if (flag(i,j) .NE. C_F) then

 !               um(i,j) = 0.d0 !v_i * xm(i) / dsqrt( xm(i) ** 2.d0 +  y(j) ** 2.d0 )
!                vm(i,j) = 0.d0 !v_i * ym(j) / dsqrt(  x(i) ** 2.d0 + ym(j) ** 2.d0 )
!
!                um(i+1,j  ) = v_i * xm(i) / dsqrt( xm(i) ** 2.d0 +  y(j) ** 2.d0 )
!                vm(i  ,j+1) = v_i * ym(j) / dsqrt(  x(i) ** 2.d0 + ym(j) ** 2.d0 )
!                
!            else if (flag(i,j) .eq. C_I) then
!
!                um(i,j) = 0.d0
!                vm(i,j+1) = 0.d0
!            
 !           endif
!
 !           enddo
 !       enddo

return
end subroutine bcUV


SUBROUTINE bcP(pn)
    USE comum
    IMPLICIT NONE
    INTEGER :: i, j
    REAL(8), DIMENSION(1:imax,1:jmax) :: pn

    !!! boundary condition

!--------contorno inferior e superior --------

    ! $omp parallel do private(i)
    do i=1,imax
        pn(i,1  ) = pn(i,2)
    enddo
    ! $omp end parallel do
    ! $omp parallel do private(i)
    do i=1,imax
        pn(i,jmax) = pn(i,jmax-1) + 1.d0*(pn(i,jmax-1)-pn(i,jmax-2))
    enddo
    ! $omp end parallel do

!-------contorno esquerdo e direito -------
    
    ! $omp parallel do private(j)
    do j=1,jmax
        pn(1  ,j) =  pn(2,j)
    enddo
    ! $omp end parallel do
    ! $omp parallel do private(j)
    do j=1,jmax
        pn(imax,j) = pn(imax-1,j)
    enddo
    ! $omp end parallel do

!    do i=1,imax
!        do j=1,jmax
!            if (flag(i,j) .eq. C_B.or.flag(i,j) .eq. C_I) then
!                pn(i,j) = 1.d0
!            endif
!        enddo
!    enddo

RETURN
END SUBROUTINE bcP



SUBROUTINE bcZ(Zn)
    USE comum
    use omp_lib
    IMPLICIT NONE
    INTEGER :: i, j
    REAL(8), DIMENSION(1:imax,1:jmax) :: Zn,gradZ_x,gradZ_y

    !!! boundary condition

!--------contorno inferior e superior --------
    ! $omp parallel do private(i)
    do i=1,imax
        Zn(i,1  ) = Zn(i,2)
    enddo
    ! $omp end parallel do
    ! $omp parallel do private(i)
    do i=1,imax
        Zn(i,jmax) = Zn(i,jmax-1) + 1.d0*(Zn(i,jmax-1)-Zn(i,jmax-2))
    enddo
    ! $omp end parallel do

!-------contorno esquerdo e direito -------
    
    ! $omp parallel do private(j)
    do j=1,jmax
        Zn(1  ,j) = Zn(2,j)
    enddo
    ! $omp end parallel do
    ! $omp parallel do private(j)
    do j=1,jmax
        Zn(imax,j) = Zn(imax-1,j)
    enddo
    ! $omp end parallel do

       i=1
        ! $omp parallel do private(j)
        do j=2,jmax-1
            gradZ_x(i,j) = x(i) * ( Zn(i+1,j) - Zn(i,j  ) ) * dx(i)
        enddo
        ! $omp end parallel do
        ! $omp parallel do private(j)
        do j=2,jmax-1
            gradZ_y(i,j) = y(j) * ( Zn(i,j+1) - Zn(i,j  ) ) * dy(j)
        enddo
        ! $omp end parallel do
       
        
        j=1
        ! $omp parallel do private(i)
        do i=1,imax-1
            gradZ_x(i,j) = x(i) * ( Zn(i+1,j) - Zn(i,j  ) ) * dx(i+1)
        enddo
        ! $omp end parallel do
        ! $omp parallel do private(i)
        do i=1,imax-1
            gradZ_y(i,j) = y(i) * ( Zn(i,j+1) - Zn(i,j  ) ) * dy(j+1)
        enddo
        ! $omp end parallel do

        ! $omp parallel do private(i, j)
        do j=2,jmax
            do i=2,imax
            gradZ_x(i,j) = x(i) * ( Zn(i,j) - Zn(i-1,j  ) ) * dx(i)
            enddo
        enddo
        ! $omp end parallel do

        ! $omp parallel do private(i, j)
        do j=2,jmax
            do i=2,imax
            gradZ_y(i,j) = y(j) * ( Zn(i,j) - Zn(i  ,j-1) ) * dy(j)
            enddo
        enddo
        ! $omp end parallel do
        
   !     do i=1,imax
   !         do j=1,jmax
   !         if (flag(i,j) .eq. C_B.or.flag(i,j) .eq. C_I) then
   !             Zn(i,j) = 5.d0 !+ gradZ_x(i,j) + gradZ_y(i,j)
   !         endif
   !         enddo
   !     enddo


RETURN
END SUBROUTINE bcZ


SUBROUTINE bcH(H)
    USE comum
    IMPLICIT NONE
    INTEGER :: i, j
    REAL(8), DIMENSION(1:imax,1:jmax) :: H

    !!! boundary condition

!--------contorno inferior e superior --------

    do i=1,imax
        H(i,1  ) = H(i,2)
        H(i,jmax) = H(i,jmax-1)
    enddo

!-------contorno esquerdo e direito -------
    
    do j=1,jmax
        H(1  ,j) = H(2,j)
        H(imax,j) = H(imax-1,j)
    enddo
    ! $omp parallel do private(i, j) 
    do j=1,jmax
        do i=1,imax
            if (flag(i,j) .eq. C_B.or.flag(i,j) .eq. C_I) then
                H(i,j) = Lf*Tsup/q + 1.d0/ (S + 1.d0)
            endif
        enddo
    enddo
    ! $OMP END PARALLEL DO

RETURN
END SUBROUTINE bcH
