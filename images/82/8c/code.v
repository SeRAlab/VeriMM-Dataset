module top_module(EXE_dvc1ByteCmp, EXE_dvc2ByteCmp, dvc2L2, dvc1L2, dofDreg, PCL_dvcByteEnL2);output [0:3] EXE_dvc1ByteCmp;
    output [0:3] EXE_dvc2ByteCmp;
    input [0:31] dvc2L2;
    input [0:31] dvc1L2;
    input [0:31] dofDreg;
    input [0:3] PCL_dvcByteEnL2;

assign EXE_dvc1ByteCmp[0] = PCL_dvcByteEnL2[0] & (~|(dvc1L2[0:7] ^ dofDreg[0:7]));
assign EXE_dvc1ByteCmp[1] = PCL_dvcByteEnL2[1] & (~|(dvc1L2[8:15] ^ dofDreg[8:15]));
assign EXE_dvc1ByteCmp[2] = PCL_dvcByteEnL2[2] & (~|(dvc1L2[16:23] ^ dofDreg[16:23]));
assign EXE_dvc1ByteCmp[3] = PCL_dvcByteEnL2[3] & (~|(dvc1L2[24:31] ^ dofDreg[24:31]));

assign EXE_dvc2ByteCmp[0] = PCL_dvcByteEnL2[0] & (~|(dvc2L2[0:7] ^ dofDreg[0:7]));
assign EXE_dvc2ByteCmp[1] = PCL_dvcByteEnL2[1] & (~|(dvc2L2[8:15] ^ dofDreg[8:15]));
assign EXE_dvc2ByteCmp[2] = PCL_dvcByteEnL2[2] & (~|(dvc2L2[16:23] ^ dofDreg[16:23]));
assign EXE_dvc2ByteCmp[3] = PCL_dvcByteEnL2[3] & (~|(dvc2L2[24:31] ^ dofDreg[24:31]));

endmodule