`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] data_in;
    reg [7:0] seg_size;
    wire [127:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .data_in(data_in),
        .seg_size(seg_size),
        .data_out(data_out),
        .valid_out(valid_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Full 128-bit segmentation", test_num);
        data_in = 128'hA5A5A5A5_B4B4B4B4_C3C3C3C3_D2D2D2D2;
        seg_size = 8'd128;

        #1;


        check_outputs(128'hA5A5A5A5_B4B4B4B4_C3C3C3C3_D2D2D2D2, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: 64-bit segmentation (Half)", test_num);
        data_in = 128'hFFFFFFFF_EEEEEEEE_DDDDDDDD_CCCCCCCC;
        seg_size = 8'd64;

        #1;


        check_outputs(128'h00000000_00000000_DDDDDDDD_CCCCCCCC, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: 43-bit segmentation (Non-standard size)", test_num);
        data_in = 128'h01234567_89ABCDEF_01234567_89ABCDEF;
        seg_size = 8'd43;

        #1;


        check_outputs(128'h00000000_00000000_00000567_89ABCDEF, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: 1-bit segmentation", test_num);
        data_in = 128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE;
        seg_size = 8'd1;

        #1;


        check_outputs(128'h0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: 100-bit segmentation", test_num);
        data_in = 128'hAAAAAAAAAAAAAAAA_BBBBBBBBBBBBBBBB;
        seg_size = 8'd100;




        #1;





        check_outputs(128'h0000000F_BBBBBBBB_BBBBBBBB_BBBBBBBB, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Zero segment size", test_num);
        data_in = 128'h12345678_9ABCDEF0_12345678_9ABCDEF0;
        seg_size = 8'd0;

        #1;


        check_outputs(128'h0, 1'b0);
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
        input [127:0] expected_data_out;
        input expected_valid_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
