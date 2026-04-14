`timescale 1ns/1ps

module checksum_calculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg valid;
    wire [7:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_calculator dut (
        .data_in(data_in),
        .valid(valid),
        .checksum_out(checksum_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: Reset Verification", test_num);
        rst_n = 0;
        data_in = 8'hFF;
        valid = 0;
        #20;
        rst_n = 1;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Basic Accumulation", test_num);
        rst_n = 0; #20; rst_n = 1; #10;

        @(posedge clk);
        data_in = 8'h10; valid = 1;
        @(posedge clk);
        data_in = 8'h20; valid = 1;
        @(posedge clk);
        valid = 0;

        #1;


        check_outputs(8'h30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Overflow Wrap-around", test_num);
        rst_n = 0; #20; rst_n = 1; #10;

        @(posedge clk);
        data_in = 8'hFF; valid = 1;
        @(posedge clk);
        data_in = 8'h02; valid = 1;
        @(posedge clk);
        valid = 0;

        #1;


        check_outputs(8'h01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Valid Signal Gating", test_num);
        rst_n = 0; #20; rst_n = 1; #10;

        @(posedge clk);
        data_in = 8'h05; valid = 1;
        @(posedge clk);
        data_in = 8'hAA; valid = 0;
        @(posedge clk);
        data_in = 8'h05; valid = 1;
        @(posedge clk);
        valid = 0;

        #1;


        check_outputs(8'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: Multi-byte Accumulation", test_num);
        rst_n = 0; #20; rst_n = 1; #10;

        @(posedge clk);
        data_in = 8'h01; valid = 1;
        @(posedge clk);
        data_in = 8'h02; valid = 1;
        @(posedge clk);
        data_in = 8'h03; valid = 1;
        @(posedge clk);
        data_in = 8'h04; valid = 1;
        @(posedge clk);
        valid = 0;

        #1;


        check_outputs(8'h0A);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_calculator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_checksum_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h",
                         checksum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h",
                         expected_checksum_out);
                $display("  Got:      checksum_out=%h",
                         checksum_out);
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
