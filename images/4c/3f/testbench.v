`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] di_PC;
    reg [31:0] icache_data;
    reg icache_hit;
    reg icache_should_stall;
    wire [31:0] do_IR;
    wire [31:0] do_NextPC;
    wire [31:0] icache_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .di_PC(di_PC),
        .icache_data(icache_data),
        .icache_hit(icache_hit),
        .icache_should_stall(icache_should_stall),
        .do_IR(do_IR),
        .do_NextPC(do_NextPC),
        .icache_address(icache_address)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Cache Hit, No Stall", test_num);
            di_PC = 32'h00001000;
            icache_data = 32'h00A00113;
            icache_hit = 1'b1;
            icache_should_stall = 1'b0;





            #1;






            check_outputs(32'h00A00113, 32'h00001004, 32'h00001000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Cache Miss", test_num);
            di_PC = 32'h00002000;
            icache_data = 32'hDEADBEEF;
            icache_hit = 1'b0;
            icache_should_stall = 1'b0;





            #1;






            check_outputs(32'h00000000, 32'h00002004, 32'h00002000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Cache Hit but Stall Active", test_num);
            di_PC = 32'h00003000;
            icache_data = 32'h12345678;
            icache_hit = 1'b1;
            icache_should_stall = 1'b1;





            #1;






            check_outputs(32'h00000000, 32'h00003004, 32'h00003000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: PC Boundary Check (Max PC)", test_num);
            di_PC = 32'hFFFFFFFC;
            icache_data = 32'h00000033;
            icache_hit = 1'b1;
            icache_should_stall = 1'b0;





            #1;






            check_outputs(32'h00000033, 32'h00000000, 32'hFFFFFFFC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Cache Miss and Stall", test_num);
            di_PC = 32'h00004564;
            icache_data = 32'hCAFEBABE;
            icache_hit = 1'b0;
            icache_should_stall = 1'b1;





            #1;






            check_outputs(32'h00000000, 32'h00004568, 32'h00004564);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Instruction and PC", test_num);
            di_PC = 32'hABCD0000;
            icache_data = 32'hF00DCAFE;
            icache_hit = 1'b1;
            icache_should_stall = 1'b0;

            #1;


            check_outputs(32'hF00DCAFE, 32'hABCD0004, 32'hABCD0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_do_IR;
        input [31:0] expected_do_NextPC;
        input [31:0] expected_icache_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_do_IR === (expected_do_IR ^ do_IR ^ expected_do_IR) &&
                expected_do_NextPC === (expected_do_NextPC ^ do_NextPC ^ expected_do_NextPC) &&
                expected_icache_address === (expected_icache_address ^ icache_address ^ expected_icache_address)) begin
                $display("PASS");
                $display("  Outputs: do_IR=%h, do_NextPC=%h, icache_address=%h",
                         do_IR, do_NextPC, icache_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: do_IR=%h, do_NextPC=%h, icache_address=%h",
                         expected_do_IR, expected_do_NextPC, expected_icache_address);
                $display("  Got:      do_IR=%h, do_NextPC=%h, icache_address=%h",
                         do_IR, do_NextPC, icache_address);
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
