`timescale 1ns/1ps

module image_convolution_tb;

    // Testbench signals (combinational circuit)
    reg [71:0] img;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    image_convolution dut (
        .img(img),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);

            img = 72'h0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Impulse at Center", test_num);


            img = {8'd0, 8'd0, 8'd0, 8'd0, 8'd10, 8'd0, 8'd0, 8'd0, 8'd0};

            #1;


            check_outputs(16'h0032);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Neighbor", test_num);

            img = {8'd0, 8'd10, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0};

            #1;


            check_outputs(16'hFFF6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Uniform Image", test_num);

            img = {9{8'd100}};

            #1;


            check_outputs(16'h0064);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Pixels", test_num);

            img = {9{8'd255}};

            #1;


            check_outputs(16'h00FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Contrast Sharpness", test_num);

            img = {8'h00, 8'd50, 8'h00, 8'd50, 8'd200, 8'd50, 8'h00, 8'd50, 8'h00};

            #1;


            check_outputs(16'h0320);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Negative Result", test_num);

            img = {8'h00, 8'd200, 8'h00, 8'd200, 8'd10, 8'd200, 8'h00, 8'd200, 8'h00};

            #1;


            check_outputs(16'hFD12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("image_convolution Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
