`timescale 1ns/1ps

module dilation_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] image_in;
    wire [8:0] image_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dilation dut (
        .image_in(image_in),
        .image_out(image_out)
    );
    task testcase001;

        begin
            test_num = 1;
            image_in = 9'b0;
            #10;
            image_in = 9'h000;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            image_in = 9'b0;
            #10;
            image_in = 9'h1FF;
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            image_in = 9'b0;
            #10;
            image_in = 9'h010;
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            image_in = 9'b0;
            #10;
            image_in = 9'h100;

            #1;


            check_outputs(9'h1B0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            image_in = 9'b0;
            #10;
            image_in = 9'h001;

            #1;


            check_outputs(9'h01B);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            image_in = 9'b0;
            #10;
            image_in = 9'h080;

            #1;


            check_outputs(9'h1F8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            image_in = 9'b0;
            #10;
            image_in = 9'h101;

            #1;


            check_outputs(9'h1BB);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            image_in = 9'b0;
            #10;
            image_in = 9'h140;

            #1;


            check_outputs(9'h1F8);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            image_in = 9'b0;
            #10;
            image_in = 9'h124;



            #1;




            check_outputs(9'h1B6);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            image_in = 9'b0;
            #10;
            image_in = 9'h049;



            #1;




            check_outputs(9'h0DB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dilation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [8:0] expected_image_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_image_out === (expected_image_out ^ image_out ^ expected_image_out)) begin
                $display("PASS");
                $display("  Outputs: image_out=%h",
                         image_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: image_out=%h",
                         expected_image_out);
                $display("  Got:      image_out=%h",
                         image_out);
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
