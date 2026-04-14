`timescale 1ns/1ps

module DAC_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] dac_input;
    wire [23:0] dac_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_Controller dut (
        .clk(clk),
        .dac_input(dac_input),
        .dac_output(dac_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        dac_input = 24'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        dac_input = 24'h000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        dac_input = 24'hFFFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(24'hFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        dac_input = 24'hAAAAAA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(24'hAAAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        dac_input = 24'h555555;
        @(posedge clk);
        #2;
        #1;

        check_outputs(24'h555555);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        dac_input = 24'h800000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(24'h800000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        dac_input = 24'h123456;
        @(posedge clk);
        #2;
        #1;

        check_outputs(24'h123456);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        dac_input = 24'hABCDEF;
        @(posedge clk);
        #2;
        dac_input = 24'h000000;
        #2;
        #1;

        check_outputs(24'hABCDEF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        dac_input = 24'h000001;
        @(posedge clk);
        dac_input = 24'h000002;
        @(posedge clk);
        dac_input = 24'h000004;
        @(posedge clk);
        dac_input = 24'h000008;
        @(posedge clk);
        #2;
        #1;

        check_outputs(24'h000008);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_Controller Testbench");
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
        input [23:0] expected_dac_output;
        begin
            if (expected_dac_output === (expected_dac_output ^ dac_output ^ expected_dac_output)) begin
                $display("PASS");
                $display("  Outputs: dac_output=%h",
                         dac_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_output=%h",
                         expected_dac_output);
                $display("  Got:      dac_output=%h",
                         dac_output);
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
        $dumpvars(0,clk, dac_input, dac_output);
    end

endmodule
