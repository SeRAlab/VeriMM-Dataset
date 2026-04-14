`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i0;
    reg i13;
    reg i14;
    reg i15;
    reg i16;
    reg i17;
    reg i18;
    reg i19;
    reg i2;
    reg i20;
    reg i22;
    reg i23;
    reg i24;
    reg i25;
    reg i27;
    reg i28;
    reg i29;
    reg i31;
    reg i32;
    reg i34;
    reg i35;
    reg i36;
    reg i37;
    reg i38;
    reg i39;
    reg i4;
    reg i40;
    reg i41;
    reg i5;
    reg i6;
    reg i7;
    reg i8;
    reg i9;
    wire o0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i0(i0),
        .i13(i13),
        .i14(i14),
        .i15(i15),
        .i16(i16),
        .i17(i17),
        .i18(i18),
        .i19(i19),
        .i2(i2),
        .i20(i20),
        .i22(i22),
        .i23(i23),
        .i24(i24),
        .i25(i25),
        .i27(i27),
        .i28(i28),
        .i29(i29),
        .i31(i31),
        .i32(i32),
        .i34(i34),
        .i35(i35),
        .i36(i36),
        .i37(i37),
        .i38(i38),
        .i39(i39),
        .i4(i4),
        .i40(i40),
        .i41(i41),
        .i5(i5),
        .i6(i6),
        .i7(i7),
        .i8(i8),
        .i9(i9),
        .o0(o0)
    );
    task clear_inputs;

        begin
            i0=0; i13=0; i14=0; i15=0; i16=0; i17=0; i18=0; i19=0; i2=0;
            i20=0; i22=0; i23=0; i24=0; i25=0; i27=0; i28=0; i29=0; i31=0;
            i32=0; i34=0; i35=0; i36=0; i37=0; i38=0; i39=0; i4=0; i40=0;
            i41=0; i5=0; i6=0; i7=0; i8=0; i9=0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: All inputs zero");
            clear_inputs();
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: All inputs one");
            i0=1; i13=1; i14=1; i15=1; i16=1; i17=1; i18=1; i19=1; i2=1;
            i20=1; i22=1; i23=1; i24=1; i25=1; i27=1; i28=1; i29=1; i31=1;
            i32=1; i34=1; i35=1; i36=1; i37=1; i38=1; i39=1; i4=1; i40=1;
            i41=1; i5=1; i6=1; i7=1; i8=1; i9=1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: MSB of first operand");
            clear_inputs();
            i14 = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: MSB of second operand");
            clear_inputs();
            i25 = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Carry propagation to MSB");
            clear_inputs();
            i13 = 1;
            i24 = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Boundary check (Sum = 511)");
            clear_inputs();
            i13 = 1;

            i23=1; i22=1; i20=1; i19=1; i18=1; i17=1; i16=1; i15=1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: 10-bit Overflow (Sum = 1024)");
            clear_inputs();
            i14 = 1;
            i25 = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Alternating bit pattern");
            clear_inputs();
            i0=1; i14=1; i16=1; i18=1; i2=1; i22=1; i24=1; i28=1; i31=1;
            i34=1; i36=1; i38=1; i40=1; i5=1; i7=1; i9=1;
            #10;


            #1;



            check_outputs(o0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_o0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0)) begin
                $display("PASS");
                $display("  Outputs: o0=%b",
                         o0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b",
                         expected_o0);
                $display("  Got:      o0=%b",
                         o0);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
