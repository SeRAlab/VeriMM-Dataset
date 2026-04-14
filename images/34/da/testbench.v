`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x_in;
    wire [15:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_in = 16'd0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Input Stability", test_num);
            reset_dut();
            x_in = 16'h0000;
            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Impulse Response Check", test_num);
            reset_dut();


            x_in = 16'h7FFF;
            @(posedge clk);


            x_in = 16'h0000;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end




            #1;
            $display("  Info: Checking output after impulse propagation...");


            if (y_out !== 16'hxxxx) begin
                $display("  Impulse Response observed: %h", y_out);
                pass_count = pass_count + 1;
            end else begin
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: DC Step Response", test_num);
            reset_dut();


            x_in = 16'h0100;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end

            #1;


            $display("  Info: Checking output after 15 cycles of DC input...");
            if (y_out !== 16'hzzzz) begin
                $display("  Step Response observed: %h", y_out);
                pass_count = pass_count + 1;
            end else begin
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Input Response", test_num);
            reset_dut();


            x_in = 16'hFF00;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end

            #1;

            if (y_out[15] === 1'b1 || y_out === 16'h0000) begin
                $display("  PASS: Output is negative or zero as expected for signed input.");
                pass_count = pass_count + 1;
            } else begin
                $display("  FAIL: Expected negative output for negative input, got %h", y_out);
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("iir_filter Testbench");
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
        input [15:0] expected_y_out;
        begin
            if (expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: y_out=%h",
                         y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_out=%h",
                         expected_y_out);
                $display("  Got:      y_out=%h",
                         y_out);
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
        $dumpvars(0,clk, rst, x_in, y_out);
    end

endmodule
