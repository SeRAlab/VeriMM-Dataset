`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_out;
    reg [4:0] dest;
    reg [4:0] src1;
    reg [4:0] src2;
    wire [31:0] forwarded_data1;
    wire [31:0] forwarded_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .data_out(data_out),
        .dest(dest),
        .src1(src1),
        .src2(src2),
        .forwarded_data1(forwarded_data1),
        .forwarded_data2(forwarded_data2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No hazards (src1, src2 != dest)", test_num);
            src1 = 5'd1;
            src2 = 5'd2;
            dest = 5'd3;
            data_out = 32'hDEADBEEF;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard detected on src1", test_num);
            src1 = 5'd10;
            src2 = 5'd11;
            dest = 5'd10;
            data_out = 32'h12345678;
            #1;

            check_outputs(32'h12345678, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard detected on src2", test_num);
            src1 = 5'd15;
            src2 = 5'd20;
            dest = 5'd20;
            data_out = 32'hABCDEF01;
            #1;

            check_outputs(32'h0, 32'hABCDEF01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard detected on both src1 and src2", test_num);
            src1 = 5'd7;
            src2 = 5'd7;
            dest = 5'd7;
            data_out = 32'h5555AAAA;
            #1;

            check_outputs(32'h5555AAAA, 32'h5555AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard on Register 0", test_num);

            src1 = 5'd0;
            src2 = 5'd5;
            dest = 5'd0;
            data_out = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard on max register index (31)", test_num);
            src1 = 5'd31;
            src2 = 5'd31;
            dest = 5'd31;
            data_out = 32'h11112222;
            #1;

            check_outputs(32'h11112222, 32'h11112222);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data to forward is zero", test_num);
            src1 = 5'd4;
            src2 = 5'd4;
            dest = 5'd4;
            data_out = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Change data_out with constant match", test_num);
            src1 = 5'd8;
            src2 = 5'd9;
            dest = 5'd8;
            data_out = 32'hCAFEFEED;
            #1;

            check_outputs(32'hCAFEFEED, 32'h0);

            data_out = 32'hBEEFCAFE;
            #1;

            check_outputs(32'hBEEFCAFE, 32'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input [31:0] expected_forwarded_data1;
        input [31:0] expected_forwarded_data2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwarded_data1 === (expected_forwarded_data1 ^ forwarded_data1 ^ expected_forwarded_data1) &&
                expected_forwarded_data2 === (expected_forwarded_data2 ^ forwarded_data2 ^ expected_forwarded_data2)) begin
                $display("PASS");
                $display("  Outputs: forwarded_data1=%h, forwarded_data2=%h",
                         forwarded_data1, forwarded_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwarded_data1=%h, forwarded_data2=%h",
                         expected_forwarded_data1, expected_forwarded_data2);
                $display("  Got:      forwarded_data1=%h, forwarded_data2=%h",
                         forwarded_data1, forwarded_data2);
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
