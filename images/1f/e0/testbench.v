`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Check", test_num);
            rst_n = 0;
            x = 8'hFF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd0);
            rst_n = 1;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Input", test_num);
            rst_n = 0; @(posedge clk);
            rst_n = 1;
            x = 8'd0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Impulse Response (Value 10)", test_num);
            rst_n = 0; @(posedge clk);
            rst_n = 1;

            x = 8'd10; @(posedge clk);
            x = 8'd0;
            repeat(7) @(posedge clk);



            #1;




            check_outputs(16'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Step Response (Constant Input 1)", test_num);
            rst_n = 0; @(posedge clk);
            rst_n = 1;

            x = 8'd1;
            repeat(8) @(posedge clk);

            #1;


            check_outputs(16'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Scale Input (255)", test_num);
            rst_n = 0; @(posedge clk);
            rst_n = 1;

            x = 8'd255;
            repeat(8) @(posedge clk);

            #1;


            check_outputs(16'd2040);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Ramp Input", test_num);
            rst_n = 0; @(posedge clk);
            rst_n = 1;

            for (i = 1; i <= 8; i = i + 1) begin
                x = i;
                @(posedge clk);
            end

            #1;


            check_outputs(16'd36);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        input [15:0] expected_y;
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
