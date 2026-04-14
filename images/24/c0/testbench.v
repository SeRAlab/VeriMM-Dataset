`timescale 1ns/1ps

module RLE_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg valid;
    wire [15:0] rle_out;
    wire rle_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE dut (
        .data_in(data_in),
        .valid(valid),
        .rle_out(rle_out),
        .rle_valid(rle_valid)
    );

    // Clock generation (10ns period)
    initial begin
        valid = 0;
        forever #5 valid = ~valid;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 8'h00;
            repeat(2) @(negedge valid);
            rst_n = 1;
            @(negedge valid);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Run of 5", test_num);
            reset_dut();
            @(negedge valid);
            data_in = 8'hAA;
            repeat(4) @(negedge valid);
            data_in = 8'hBB;
            @(posedge valid);
            #1;
            #1;

            check_outputs(16'hAA05, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Occurrence Run", test_num);
            reset_dut();
            @(negedge valid);
            data_in = 8'h55;
            @(negedge valid);
            data_in = 8'h66;
            @(posedge valid);
            #1;
            #1;

            check_outputs(16'h5501, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Run Length (255)", test_num);
            reset_dut();
            @(negedge valid);
            data_in = 8'hFF;
            repeat(254) @(negedge valid);
            data_in = 8'h00;
            @(posedge valid);
            #1;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Run of Zeroes", test_num);
            reset_dut();
            @(negedge valid);
            data_in = 8'h00;
            repeat(9) @(negedge valid);
            data_in = 8'h01;
            @(posedge valid);
            #1;
            #1;

            check_outputs(16'h000A, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Consecutive Runs", test_num);
            reset_dut();
            @(negedge valid);
            data_in = 8'h11;
            repeat(2) @(negedge valid);
            data_in = 8'h22;
            repeat(3) @(negedge valid);
            data_in = 8'h33;
            @(posedge valid);
            #1;
            #1;

            check_outputs(16'h2204, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE Testbench");
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
        input [15:0] expected_rle_out;
        input expected_rle_valid;
        begin
            if (expected_rle_out === (expected_rle_out ^ rle_out ^ expected_rle_out) &&
                expected_rle_valid === (expected_rle_valid ^ rle_valid ^ expected_rle_valid)) begin
                $display("PASS");
                $display("  Outputs: rle_out=%h, rle_valid=%b",
                         rle_out, rle_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rle_out=%h, rle_valid=%b",
                         expected_rle_out, expected_rle_valid);
                $display("  Got:      rle_out=%h, rle_valid=%b",
                         rle_out, rle_valid);
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
        $dumpvars(0,data_in, valid, rle_out, rle_valid);
    end

endmodule
