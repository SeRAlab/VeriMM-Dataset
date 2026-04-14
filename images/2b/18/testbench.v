`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] payload;
    reg [2:0] seg_type;
    wire error;
    wire [15:0] seg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .payload(payload),
        .seg_type(seg_type),
        .error(error),
        .seg_out(seg_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Type 000 (No segmentation)", test_num);
            payload = 16'hABCD;
            seg_type = 3'b000;
            #1;

            check_outputs(1'b0, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Type 001 (2 x 8-bit)", test_num);
            payload = 16'h1234;
            seg_type = 3'b001;
            #1;

            check_outputs(1'b0, 16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Type 010 (4 x 4-bit)", test_num);
            payload = 16'hF0E1;
            seg_type = 3'b010;
            #1;

            check_outputs(1'b0, 16'hF0E1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Type 011 (8 x 2-bit)", test_num);
            payload = 16'h55AA;
            seg_type = 3'b011;
            #1;

            check_outputs(1'b0, 16'h55AA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Type 100 (16 x 1-bit)", test_num);
            payload = 16'hFFFF;
            seg_type = 3'b100;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Type 101 (Invalid)", test_num);
            payload = 16'h0000;
            seg_type = 3'b101;

            #1;


            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Type 110 (Invalid)", test_num);
            payload = 16'h1234;
            seg_type = 3'b110;




            #1;
            if (error === 1'b1) begin
                $display("PASS (Error bit correctly set)");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL (Error bit not set)");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Type 111 (Invalid)", test_num);
            payload = 16'hFFFF;
            seg_type = 3'b111;
            #1;
            if (error === 1'b1) begin
                $display("PASS (Error bit correctly set)");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL (Error bit not set)");
                fail_count = fail_count + 1;
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
        $display("tcp_segmenter Testbench");
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
        input expected_error;
        input [15:0] expected_seg_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_seg_out === (expected_seg_out ^ seg_out ^ expected_seg_out)) begin
                $display("PASS");
                $display("  Outputs: error=%b, seg_out=%h",
                         error, seg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, seg_out=%h",
                         expected_error, expected_seg_out);
                $display("  Got:      error=%b, seg_out=%h",
                         error, seg_out);
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
