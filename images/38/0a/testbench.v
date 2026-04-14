`timescale 1ns/1ps

module butterworth_filter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    butterworth_filter dut (
        .x(x),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Reset and Zero Input", test_num);

        rst = 1;
        x = 4'h0;
        @(posedge clk);
        #1;
        rst = 0;

        repeat(10) @(posedge clk);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: DC Step Response (8)", test_num);

        rst = 1;
        x = 4'h0;
        @(posedge clk);
        #1;
        rst = 0;

        x = 4'h8;
        repeat(20) @(posedge clk);

        #1;


        check_outputs(4'h8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: DC Step Response (15)", test_num);

        rst = 1;
        x = 4'h0;
        @(posedge clk);
        #1;
        rst = 0;

        x = 4'hF;
        repeat(20) @(posedge clk);

        #1;


        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Impulse Response Decay", test_num);

        rst = 1;
        x = 4'h0;
        @(posedge clk);
        #1;
        rst = 0;

        x = 4'hF;
        @(posedge clk);
        x = 4'h0;

        repeat(20) @(posedge clk);

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: High Frequency Attenuation", test_num);

        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;

        repeat(15) begin
            x = 4'hF; @(posedge clk);
            x = 4'h0; @(posedge clk);
        end



        if (y > 4'h4 && y < 4'hB) begin
            #1;

            check_outputs(y);
        end else begin
            #1;

            check_outputs(4'h7);
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
        $display("butterworth_filter Testbench");
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
