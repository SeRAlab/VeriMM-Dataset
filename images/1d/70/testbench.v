`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg segment_enable;
    wire [7:0] data_out1;
    wire [7:0] data_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .data_in(data_in),
        .segment_enable(segment_enable),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 16'hABCD;
            segment_enable = 1'b1;
            $display("Test %0d: Basic Segmentation Enabled (Input: %h)", test_num, data_in);
            #1;

            check_outputs(8'hAB, 8'hCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 16'h1234;
            segment_enable = 1'b0;
            $display("Test %0d: Segmentation Disabled - Expecting zero/inactive outputs (Input: %h)", test_num, data_in);

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 16'hFFFF;
            segment_enable = 1'b1;
            $display("Test %0d: All ones segmentation (Input: %h)", test_num, data_in);
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 16'h0000;
            segment_enable = 1'b1;
            $display("Test %0d: All zeros segmentation (Input: %h)", test_num, data_in);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 16'hA55A;
            segment_enable = 1'b1;
            $display("Test %0d: Alternating bit patterns (Input: %h)", test_num, data_in);
            #1;

            check_outputs(8'hA5, 8'h5A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 16'h7F80;
            segment_enable = 1'b1;
            $display("Test %0d: Boundary values (Input: %h)", test_num, data_in);
            #1;

            check_outputs(8'h7F, 8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 16'h55AA;
            segment_enable = 1'b0;
            $display("Test %0d: Ensure logic remains 0 when disabled after enable was high (Input: %h)", test_num, data_in);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmentation Testbench");
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h",
                         expected_data_out1, expected_data_out2);
                $display("  Got:      data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
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
