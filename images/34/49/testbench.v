`timescale 1ns/1ps

module data_forwarding_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest;
    reg [31:0] exec_val;
    reg [4:0] src1;
    reg [4:0] src2;
    wire [31:0] out1;
    wire [31:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding dut (
        .dest(dest),
        .exec_val(exec_val),
        .src1(src1),
        .src2(src2),
        .out1(out1),
        .out2(out2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Match - Original values expected", test_num);
            dest = 5'd31;
            exec_val = 32'hCAFE_BABE;
            src1 = 5'd10;
            src2 = 5'd20;
            #1;

            check_outputs(32'd10, 32'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Match src1 - out1 should be exec_val", test_num);
            dest = 5'd15;
            exec_val = 32'h1234_5678;
            src1 = 5'd15;
            src2 = 5'd7;
            #1;

            check_outputs(32'h1234_5678, 32'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Match src2 - out2 should be exec_val", test_num);
            dest = 5'd22;
            exec_val = 32'h8765_4321;
            src1 = 5'd11;
            src2 = 5'd22;
            #1;

            check_outputs(32'd11, 32'h8765_4321);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Match Both - Both outputs should be exec_val", test_num);
            dest = 5'd8;
            exec_val = 32'hDEAD_BEEF;
            src1 = 5'd8;
            src2 = 5'd8;
            #1;

            check_outputs(32'hDEAD_BEEF, 32'hDEAD_BEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Register Match", test_num);
            dest = 5'd0;
            exec_val = 32'hFFFF_FFFF;
            src1 = 5'd0;
            src2 = 5'd1;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Values (Max Index 31)", test_num);
            dest = 5'd31;
            exec_val = 32'h55AA_55AA;
            src1 = 5'd31;
            src2 = 5'd31;
            #1;

            check_outputs(32'h55AA_55AA, 32'h55AA_55AA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding Testbench");
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
        input [31:0] expected_out1;
        input [31:0] expected_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
