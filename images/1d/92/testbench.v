`timescale 1ns/1ps

module dwt_2d_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] pixel_in;
    wire [7:0] approx_out;
    wire [7:0] detail_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_2d dut (
        .pixel_in(pixel_in),
        .approx_out(approx_out),
        .detail_out(detail_out)
    );
    task testcase001;

    begin
        test_num = 1;
        pixel_in = 16'h0000;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        pixel_in = 16'hFFFF;

        #1;


        check_outputs(8'hFF, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        pixel_in = 16'hAAAA;
        #1;

        check_outputs(8'hAA, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        pixel_in = 16'hF0F0;
        #1;

        check_outputs(8'hAA, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        pixel_in = 16'h5A5A;
        #1;

        check_outputs(8'hAA, 8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        pixel_in = 16'h0001;
        #1;

        check_outputs(8'h01, 8'h01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        pixel_in = 16'hCC00;
        #1;

        check_outputs(8'hC0, 8'h40);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_2d Testbench");
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
        input [7:0] expected_approx_out;
        input [7:0] expected_detail_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_approx_out === (expected_approx_out ^ approx_out ^ expected_approx_out) &&
                expected_detail_out === (expected_detail_out ^ detail_out ^ expected_detail_out)) begin
                $display("PASS");
                $display("  Outputs: approx_out=%h, detail_out=%h",
                         approx_out, detail_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx_out=%h, detail_out=%h",
                         expected_approx_out, expected_detail_out);
                $display("  Got:      approx_out=%h, detail_out=%h",
                         approx_out, detail_out);
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
