`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] F_ecc_data;
    reg Res;
    reg WrECC;
    reg clk;
    reg error_bv;
    wire ECC_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .F_ecc_data(F_ecc_data),
        .Res(Res),
        .WrECC(WrECC),
        .clk(clk),
        .error_bv(error_bv),
        .ECC_status(ECC_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Res = 1;
            F_ecc_data = 0;
            WrECC = 0;
            error_bv = 0;
            @(posedge clk);
            #1;
            Res = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset State Initialization", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Valid Data (All 0s), error_bv=0", test_num);
            reset_dut();
            @(posedge clk);
            F_ecc_data = 7'b0000000;
            WrECC = 1;
            error_bv = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Valid Data, error_bv=1", test_num);
            reset_dut();
            @(posedge clk);
            F_ecc_data = 7'b0000000;
            WrECC = 1;
            error_bv = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Single bit flip (Bit 0) - Parity Error", test_num);
            reset_dut();
            @(posedge clk);
            F_ecc_data = 7'b0000001;
            WrECC = 1;
            error_bv = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Single bit flip (Bit 3) - Parity Error", test_num);
            reset_dut();
            @(posedge clk);
            F_ecc_data = 7'b0001000;
            WrECC = 1;
            error_bv = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Write Disable (WrECC=0) prevents data update", test_num);
            reset_dut();

            @(posedge clk);
            F_ecc_data = 7'b0000000;
            WrECC = 1;
            @(posedge clk);
            #1;

            @(posedge clk);
            F_ecc_data = 7'b1111111;
            WrECC = 0;
            error_bv = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Parity Error + External Error", test_num);
            reset_dut();
            @(posedge clk);
            F_ecc_data = 7'b1111111;
            WrECC = 1;
            error_bv = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Clear ECC status with new valid data", test_num);
            reset_dut();

            @(posedge clk);
            F_ecc_data = 7'b0000111;
            WrECC = 1;
            @(posedge clk);
            #1;

            @(posedge clk);
            F_ecc_data = 7'b0000000;
            WrECC = 1;
            error_bv = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
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
        input expected_ECC_status;
        begin
            if (expected_ECC_status === (expected_ECC_status ^ ECC_status ^ expected_ECC_status)) begin
                $display("PASS");
                $display("  Outputs: ECC_status=%b",
                         ECC_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ECC_status=%b",
                         expected_ECC_status);
                $display("  Got:      ECC_status=%b",
                         ECC_status);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,F_ecc_data, Res, WrECC, clk, error_bv, ECC_status);
    end

endmodule
