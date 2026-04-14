`timescale 1ns/1ps

module zzadd32op4_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    reg [31:0] rs3_data;
    reg [31:0] rs4_data;
    wire [31:0] adder_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zzadd32op4 dut (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rs3_data(rs3_data),
        .rs4_data(rs4_data),
        .adder_out(adder_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition", test_num);
            rs1_data = 32'd10;
            rs2_data = 32'd20;
            rs3_data = 32'd30;
            rs4_data = 32'd40;
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs", test_num);
            rs1_data = 32'h0;
            rs2_data = 32'h0;
            rs3_data = 32'h0;
            rs4_data = 32'h0;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Wrap-around (1 + Max)", test_num);
            rs1_data = 32'hFFFFFFFF;
            rs2_data = 32'h00000001;
            rs3_data = 32'h00000000;
            rs4_data = 32'h00000000;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Values Addition", test_num);
            rs1_data = 32'h10000000;
            rs2_data = 32'h20000000;
            rs3_data = 32'h30000000;
            rs4_data = 32'h40000000;
            #1;

            check_outputs(32'hA0000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Operands Max Value", test_num);
            rs1_data = 32'hFFFFFFFF;
            rs2_data = 32'hFFFFFFFF;
            rs3_data = 32'hFFFFFFFF;
            rs4_data = 32'hFFFFFFFF;


            #1;



            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            rs1_data = 32'hAAAAAAAA;
            rs2_data = 32'h55555555;
            rs3_data = 32'hAAAAAAAA;
            rs4_data = 32'h55555555;


            #1;



            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Small and Large", test_num);
            rs1_data = 32'h7FFFFFFF;
            rs2_data = 32'h7FFFFFFF;
            rs3_data = 32'h00000001;
            rs4_data = 32'h00000001;


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zzadd32op4 Testbench");
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
        input [31:0] expected_adder_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adder_out === (expected_adder_out ^ adder_out ^ expected_adder_out)) begin
                $display("PASS");
                $display("  Outputs: adder_out=%h",
                         adder_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adder_out=%h",
                         expected_adder_out);
                $display("  Got:      adder_out=%h",
                         adder_out);
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
