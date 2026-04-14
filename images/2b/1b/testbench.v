`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg valid;
    wire [31:0] data_out;
    wire data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .data_in(data_in),
        .valid(valid),
        .data_out(data_out),
        .data_ready(data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 8'h0;
            valid = 1'b0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: Sequential Input", test_num);

            @(negedge clk);
            data_in = 8'h12; valid = 1'b1; @(negedge clk);
            data_in = 8'h34; valid = 1'b1; @(negedge clk);
            data_in = 8'h56; valid = 1'b1; @(negedge clk);
            data_in = 8'h78; valid = 1'b1; @(negedge clk);
            valid = 1'b0;

            #1;


            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: Intermittent Valid", test_num);

            @(negedge clk);
            data_in = 8'hAA; valid = 1'b1; @(negedge clk);
            data_in = 8'h00; valid = 1'b0; @(negedge clk);
            data_in = 8'hBB; valid = 1'b1; @(negedge clk);
            data_in = 8'hCC; valid = 1'b1; @(negedge clk);
            data_in = 8'hFF; valid = 1'b0; @(negedge clk);
            data_in = 8'hDD; valid = 1'b1; @(negedge clk);
            valid = 1'b0;

            #1;


            check_outputs(32'hAABBCCDD, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: Back-to-Back Transfers", test_num);


            @(negedge clk);
            data_in = 8'h11; valid = 1'b1; @(negedge clk);
            data_in = 8'h22; valid = 1'b1; @(negedge clk);
            data_in = 8'h33; valid = 1'b1; @(negedge clk);
            data_in = 8'h44; valid = 1'b1; @(negedge clk);


            data_in = 8'h88; valid = 1'b1; @(negedge clk);
            data_in = 8'h77; valid = 1'b1; @(negedge clk);
            data_in = 8'h66; valid = 1'b1; @(negedge clk);
            data_in = 8'h55; valid = 1'b1; @(negedge clk);
            valid = 1'b0;

            #1;


            check_outputs(32'h88776655, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Zeros Data", test_num);

            @(negedge clk);
            data_in = 8'h00; valid = 1'b1; @(negedge clk);
            data_in = 8'h00; valid = 1'b1; @(negedge clk);
            data_in = 8'h00; valid = 1'b1; @(negedge clk);
            data_in = 8'h00; valid = 1'b1; @(negedge clk);
            valid = 1'b0;

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: Boundary Max Values", test_num);

            @(negedge clk);
            data_in = 8'hFF; valid = 1'b1; @(negedge clk);
            data_in = 8'hFF; valid = 1'b1; @(negedge clk);
            data_in = 8'hFF; valid = 1'b1; @(negedge clk);
            data_in = 8'hFF; valid = 1'b1; @(negedge clk);
            valid = 1'b0;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input [31:0] expected_data_out;
        input expected_data_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b",
                         data_out, data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b",
                         expected_data_out, expected_data_ready);
                $display("  Got:      data_out=%h, data_ready=%b",
                         data_out, data_ready);
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
        $dumpvars(0,clk, data_in, valid, data_out, data_ready);
    end

endmodule
