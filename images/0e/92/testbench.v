`timescale 1ns/1ps

module adc_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] analog_in;
    wire [15:0] digital_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_16bit dut (
        .analog_in(analog_in),
        .digital_out(digital_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum input (0)", test_num);
            analog_in = 10'd0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum input (1023)", test_num);
            analog_in = 10'd1023;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Midpoint input (511)", test_num);
            analog_in = 10'd511;


            #1;



            check_outputs(16'h7FDF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small input (1)", test_num);
            analog_in = 10'd1;

            #1;


            check_outputs(16'h0040);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Power of 2 input (64)", test_num);
            analog_in = 10'd64;

            #1;


            check_outputs(16'h1004);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating bit pattern (682)", test_num);
            analog_in = 10'h2AA;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High range input (768)", test_num);
            analog_in = 10'd768;

            #1;


            check_outputs(16'hC030);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed bits input (123)", test_num);
            analog_in = 10'd123;


            #1;



            check_outputs(16'h1ED7);





            #1;






            check_outputs(16'h1EC7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_digital_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_out === (expected_digital_out ^ digital_out ^ expected_digital_out)) begin
                $display("PASS");
                $display("  Outputs: digital_out=%h",
                         digital_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_out=%h",
                         expected_digital_out);
                $display("  Got:      digital_out=%h",
                         digital_out);
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
