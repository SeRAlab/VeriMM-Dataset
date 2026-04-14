`timescale 1ns/1ps

module zckenbuf_prim_tb;

    // Testbench signals (combinational circuit)
    reg en_l;
    reg rclk;
    reg tm_l;
    wire clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zckenbuf_prim dut (
        .en_l(en_l),
        .rclk(rclk),
        .tm_l(tm_l),
        .clk(clk)
    );
    task testcase001;


        begin
            test_num = 1;

            rclk = 0;
            en_l = 1'b1;
            tm_l = 1'b1;
            #10;


            rclk = 1;
            #10;


            #1;



            check_outputs(1'b0);


            #10 rclk = 0;
        end
        endtask

    task testcase002;


        begin
            test_num = 2;

            rclk = 0;
            en_l = 1'b0;
            tm_l = 1'b1;
            #10;


            rclk = 1;
            #10;


            #1;



            check_outputs(1'b1);

            #10 rclk = 0;
        end
        endtask

    task testcase003;


        begin
            test_num = 3;

            rclk = 0;
            en_l = 1'b1;
            tm_l = 1'b0;
            #10;


            rclk = 1;
            #10;


            #1;



            check_outputs(1'b1);

            #10 rclk = 0;
        end
        endtask

    task testcase004;


        begin
            test_num = 4;

            rclk = 0;
            en_l = 1'b0;
            tm_l = 1'b0;
            #10;


            rclk = 1;
            #10;


            #1;



            check_outputs(1'b1);

            #10 rclk = 0;
        end
        endtask

    task testcase005;


        begin
            test_num = 5;

            rclk = 0;
            en_l = 1'b0;
            tm_l = 1'b0;
            #10;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase006;




        begin
            test_num = 6;

            rclk = 0;
            en_l = 1'b0;
            tm_l = 1'b1;
            #10;

            rclk = 1;
            #5;

            en_l = 1'b1;
            #5;


            #1;



            check_outputs(1'b1);

            #10 rclk = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zckenbuf_prim Testbench");
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
        input expected_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk === (expected_clk ^ clk ^ expected_clk)) begin
                $display("PASS");
                $display("  Outputs: clk=%b",
                         clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b",
                         expected_clk);
                $display("  Got:      clk=%b",
                         clk);
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
