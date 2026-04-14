`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg segment;
    wire [7:0] data_out1;
    wire [7:0] data_out2;
    wire [15:0] data_out_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .data_in(data_in),
        .segment(segment),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .data_out_full(data_out_full)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Segmentation Enabled - Input 0xABCD", test_num);
        data_in = 16'hABCD;
        segment = 1'b1;

        #1;


        check_outputs(8'hAB, 8'hCD, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Segmentation Disabled - Input 0xABCD", test_num);
        data_in = 16'hABCD;
        segment = 1'b0;

        #1;


        check_outputs(8'h00, 8'h00, 16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Segmentation Enabled - Input 0xFFFF", test_num);
        data_in = 16'hFFFF;
        segment = 1'b1;

        #1;


        check_outputs(8'hFF, 8'hFF, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Segmentation Disabled - Input 0xFFFF", test_num);
        data_in = 16'hFFFF;
        segment = 1'b0;

        #1;


        check_outputs(8'h00, 8'h00, 16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Segmentation Enabled - Input 0x0000", test_num);
        data_in = 16'h0000;
        segment = 1'b1;

        #1;


        check_outputs(8'h00, 8'h00, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Segmentation Disabled - Input 0x0000", test_num);
        data_in = 16'h0000;
        segment = 1'b0;

        #1;


        check_outputs(8'h00, 8'h00, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Segmentation Enabled - Alternating Pattern 0xAAAA", test_num);
        data_in = 16'hAAAA;
        segment = 1'b1;

        #1;


        check_outputs(8'hAA, 8'hAA, 16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Segmentation Disabled - Alternating Pattern 0x5555", test_num);
        data_in = 16'h5555;
        segment = 1'b0;

        #1;


        check_outputs(8'h00, 8'h00, 16'h5555);
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        input [15:0] expected_data_out_full;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2) &&
                expected_data_out_full === (expected_data_out_full ^ data_out_full ^ expected_data_out_full)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h, data_out_full=%h",
                         data_out1, data_out2, data_out_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h, data_out_full=%h",
                         expected_data_out1, expected_data_out2, expected_data_out_full);
                $display("  Got:      data_out1=%h, data_out2=%h, data_out_full=%h",
                         data_out1, data_out2, data_out_full);
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
