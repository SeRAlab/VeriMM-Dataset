`timescale 1ns/1ps

module data_storage_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_data;
    reg in_valid;
    reg reset;
    wire [31:0] out_data;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_storage dut (
        .clk(clk),
        .in_data(in_data),
        .in_valid(in_valid),
        .reset(reset),
        .out_data(out_data),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_data = 32'h0;
            in_valid = 1'b0;
            #15;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Data Storage");
            reset_dut();
            @(posedge clk);
            in_data = 32'hDEADBEEF;
            in_valid = 1'b1;
            @(posedge clk);
            in_valid = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: out_valid Pulse Behavior");
            reset_dut();
            @(posedge clk);
            in_data = 32'h11223344;
            in_valid = 1'b1;
            @(posedge clk);
            in_valid = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h11223344, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Asynchronous Reset");
            reset_dut();
            @(posedge clk);
            in_data = 32'hFFFFFFFF;
            in_valid = 1'b1;
            @(posedge clk);

            reset = 1'b1;
            #5;
            #1;

            check_outputs(32'h00000000, 1'b0);
            reset = 1'b0;
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Zero Data Input");
            reset_dut();
            @(posedge clk);
            in_data = 32'h00000000;
            in_valid = 1'b1;
            @(posedge clk);
            in_valid = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Max Data Input");
            reset_dut();
            @(posedge clk);
            in_data = 32'hFFFFFFFF;
            in_valid = 1'b1;
            @(posedge clk);
            in_valid = 1'b0;
            @(posedge clk);
            #1;
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
        $display("data_storage Testbench");
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
        input [31:0] expected_out_data;
        input expected_out_valid;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h, out_valid=%b",
                         out_data, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h, out_valid=%b",
                         expected_out_data, expected_out_valid);
                $display("  Got:      out_data=%h, out_valid=%b",
                         out_data, out_valid);
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
        $dumpvars(0,clk, in_data, in_valid, reset, out_data, out_valid);
    end

endmodule
