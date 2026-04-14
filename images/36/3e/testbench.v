`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in0;
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg [1:0] select;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting Input 0 (0xAAAAAAAA)", test_num);
            in0 = 32'hAAAAAAAA;
            in1 = 32'hFFFFFFFF;
            in2 = 32'h00000000;
            in3 = 32'h12345678;
            select = 2'b00;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting Input 1 (0x55555555)", test_num);
            in0 = 32'h00000000;
            in1 = 32'h55555555;
            in2 = 32'hFFFFFFFF;
            in3 = 32'h87654321;
            select = 2'b01;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting Input 2 (All Zeros)", test_num);
            in0 = 32'hDEADBEEF;
            in1 = 32'hCAFEBABE;
            in2 = 32'h00000000;
            in3 = 32'hFFFFFFFF;
            select = 2'b10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting Input 3 (All Ones)", test_num);
            in0 = 32'h11111111;
            in1 = 32'h22222222;
            in2 = 32'h33333333;
            in3 = 32'hFFFFFFFF;
            select = 2'b11;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data change on active channel (Input 2)", test_num);
            in2 = 32'h00001111;
            select = 2'b10;
            #5;
            in2 = 32'hABCDEF01;
            #1;

            check_outputs(32'hABCDEF01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selection switching sequence", test_num);
            in0 = 32'h1; in1 = 32'h2; in2 = 32'h3; in3 = 32'h4;

            select = 2'b00; #2;
            select = 2'b11; #2;
            #1;

            check_outputs(32'h4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Walking bit test", test_num);
            in0 = 32'h80000000;
            select = 2'b00;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
