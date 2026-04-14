`timescale 1ns/1ps

module checksum_checker_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] checksum_in;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid;
    wire [7:0] checksum_out;
    wire data_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_checker dut (
        .checksum_in(checksum_in),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .checksum_out(checksum_out),
        .data_valid(data_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clk = 0;
            valid = 0;
            data_in = 8'h0;
            checksum_in = 8'h0;
            #10;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single byte sum", test_num);
            reset_dut();

            data_in = 8'hA5;
            checksum_in = 8'hA5;
            valid = 1;
            @(posedge clk);
            #1;
            valid = 0;


            #1;



            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple bytes sum (no overflow)", test_num);
            reset_dut();


            data_in = 8'h10;
            valid = 1;
            @(posedge clk);
            #1;


            data_in = 8'h20;
            @(posedge clk);
            #1;


            data_in = 8'h05;
            checksum_in = 8'h35;
            @(posedge clk);
            #1;

            valid = 0;
            #1;

            check_outputs(8'h35, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checksum overflow (Modulo 256)", test_num);
            reset_dut();


            data_in = 8'hFF;
            valid = 1;
            @(posedge clk);
            #1;

            data_in = 8'h02;
            checksum_in = 8'h01;
            @(posedge clk);
            #1;

            valid = 0;
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Invalid checksum verification", test_num);
            reset_dut();

            data_in = 8'h50;
            valid = 1;
            @(posedge clk);
            #1;

            data_in = 8'h50;
            checksum_in = 8'hAA;
            @(posedge clk);
            #1;

            valid = 0;

            #1;


            check_outputs(8'hA0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Valid signal behavior (ignoring data when valid=0)", test_num);
            reset_dut();


            data_in = 8'h10;
            valid = 1;
            @(posedge clk);
            #1;


            data_in = 8'h99;
            valid = 0;
            @(posedge clk);
            #1;


            data_in = 8'h10;
            valid = 1;
            checksum_in = 8'h20;
            @(posedge clk);
            #1;

            valid = 0;
            #1;

            check_outputs(8'h20, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum values and multiple overflows", test_num);
            reset_dut();

            valid = 1;
            data_in = 8'hFF;
            @(posedge clk); #1;
            data_in = 8'hFF;
            @(posedge clk); #1;
            data_in = 8'hFF;
            @(posedge clk); #1;

            checksum_in = 8'hFD;
            valid = 0;
            #1;

            check_outputs(8'hFD, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_checker Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_data_valid;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, data_valid=%b",
                         checksum_out, data_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, data_valid=%b",
                         expected_checksum_out, expected_data_valid);
                $display("  Got:      checksum_out=%h, data_valid=%b",
                         checksum_out, data_valid);
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
        $dumpvars(0,checksum_in, clk, data_in, reset, valid, checksum_out, data_valid);
    end

endmodule
