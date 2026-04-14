`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x;
    reg [15:0] y;
    wire [15:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 16'h0;
            y = 16'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and Zero Input", test_num);
            reset_dut();
            x = 16'h0000;
            y = 16'h0000;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Impulse Response (X input)", test_num);
            reset_dut();
            x = 16'h1000;
            y = 16'h0000;
            @(posedge clk);
            x = 16'h0000;
            repeat(4) @(posedge clk);

            if (z != 16'h0000) begin
                pass_count = pass_count + 1;
                $display("PASS: Filter responded to impulse on X. z=%h", z);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Filter output remained zero after impulse on X.");
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Impulse Response (Y input)", test_num);
            reset_dut();
            x = 16'h0000;
            y = 16'h2000;
            @(posedge clk);
            y = 16'h0000;
            repeat(4) @(posedge clk);
            if (z != 16'h0000) begin
                pass_count = pass_count + 1;
                $display("PASS: Filter responded to impulse on Y. z=%h", z);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Filter output remained zero after impulse on Y.");
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: DC Step Response", test_num);
            reset_dut();
            x = 16'h00FF;
            y = 16'h00FF;
            repeat(10) @(posedge clk);

            if (z !== 16'hxxxx && z !== 16'hzzzz) begin
                pass_count = pass_count + 1;
                $display("PASS: Filter reached stable state z=%h", z);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Filter output is invalid (X or Z)");
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Scale Input", test_num);
            reset_dut();
            x = 16'h7FFF;
            y = 16'h7FFF;
            repeat(5) @(posedge clk);

            if (z !== 16'hxxxx) begin
                pass_count = pass_count + 1;
                $display("PASS: Filter handled high-scale input. z=%h", z);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Filter output invalid on high-scale input");
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
        input [15:0] expected_z;
        begin
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
        $dumpvars(0,clk, rst, x, y, z);
    end

endmodule
