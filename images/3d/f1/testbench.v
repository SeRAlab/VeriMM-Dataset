`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] x;
    wire [15:0] e;
    wire [15:0] w0;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms_filter dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .x(x),
        .e(e),
        .w0(w0),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 16'h0;
            d = 16'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            x = 16'h0000;
            d = 16'h0000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input Signal", test_num);
            reset_dut();

            x = 16'h0000;
            d = 16'h1234;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h1234, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Step Calculation", test_num);
            reset_dut();

            x = 16'h0002;
            d = 16'h0010;
            @(posedge clk);
            #1;





            #1;






            check_outputs(16'h0010, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        reg [15:0] prev_w0;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Weight Update Direction (Positive)", test_num);
            reset_dut();

            x = 16'h0001;
            d = 16'h0100;

            @(posedge clk); #1;
            @(posedge clk); #1;

            if (w0 > 16'h0000 && e < 16'h0100) begin
                $display("PASS: Weight increased and error decreased");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Weight did not increase. w0=%h, e=%h", w0, e);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        integer i;
        reg [15:0] final_e;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Convergence Test", test_num);
            reset_dut();

            x = 16'h0040;
            d = 16'h0040;


            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            final_e = e;

            if (final_e < 16'h0010) begin
                $display("PASS: Filter converged. Final Error: %h", final_e);
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: Filter failed to converge. Final Error: %h", final_e);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Correlation", test_num);
            reset_dut();

            x = 16'h0010;
            d = 16'hFFF0;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;


            if (w0[15] == 1'b1) begin
                $display("PASS: Weight moving in negative direction. w0=%h", w0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Weight is not negative. w0=%h", w0);
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
        $display("adaptive_lms_filter Testbench");
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
        input [15:0] expected_e;
        input [15:0] expected_w0;
        input [15:0] expected_y;
        begin
            if (expected_e === (expected_e ^ e ^ expected_e) &&
                expected_w0 === (expected_w0 ^ w0 ^ expected_w0) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: e=%h, w0=%h, y=%h",
                         e, w0, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e=%h, w0=%h, y=%h",
                         expected_e, expected_w0, expected_y);
                $display("  Got:      e=%h, w0=%h, y=%h",
                         e, w0, y);
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
        $dumpvars(0,clk, d, reset, x, e, w0, y);
    end

endmodule
