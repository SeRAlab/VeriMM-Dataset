`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a1;
    reg [31:0] a10;
    reg [31:0] a11;
    reg [31:0] a12;
    reg [31:0] a13;
    reg [31:0] a2;
    reg [31:0] a3;
    reg [31:0] a4;
    reg [31:0] a5;
    reg [31:0] a6;
    reg [31:0] a7;
    reg [31:0] a8;
    reg [31:0] a9;
    reg [3:0] choose;
    wire [31:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a1(a1),
        .a10(a10),
        .a11(a11),
        .a12(a12),
        .a13(a13),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .a5(a5),
        .a6(a6),
        .a7(a7),
        .a8(a8),
        .a9(a9),
        .choose(choose),
        .z(z)
    );
    task initialize_inputs;

        begin
            a1  = 32'h1111_1111;
            a2  = 32'h2222_2222;
            a3  = 32'h3333_3333;
            a4  = 32'h4444_4444;
            a5  = 32'h5555_5555;
            a6  = 32'h6666_6666;
            a7  = 32'h7777_7777;
            a8  = 32'h8888_8888;
            a9  = 32'h9999_9999;
            a10 = 32'hAAAA_AAAA;
            a11 = 32'hBBBB_BBBB;
            a12 = 32'hCCCC_CCCC;
            a13 = 32'hDDDD_DDDD;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            initialize_inputs();
            choose = 4'b0000;
            $display("Testcase %0d: Select a1 (choose=0000)", test_num);
            #1;

            check_outputs(a1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            initialize_inputs();
            choose = 4'b0001;
            $display("Testcase %0d: Select a2 (choose=0001)", test_num);
            #1;

            check_outputs(a2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            initialize_inputs();
            choose = 4'b0010;
            $display("Testcase %0d: Select a3 (choose=0010)", test_num);
            #1;

            check_outputs(a3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            initialize_inputs();
            choose = 4'b0011;
            $display("Testcase %0d: Select a4 (choose=0011)", test_num);
            #1;

            check_outputs(a4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            initialize_inputs();
            choose = 4'b0100;
            $display("Testcase %0d: Select a5 (choose=0100)", test_num);
            #1;

            check_outputs(a5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            initialize_inputs();
            choose = 4'b0101;
            $display("Testcase %0d: Select a6 (choose=0101)", test_num);
            #1;

            check_outputs(a6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            initialize_inputs();
            choose = 4'b0110;
            $display("Testcase %0d: Select a7 (choose=0110)", test_num);
            #1;

            check_outputs(a7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            initialize_inputs();
            choose = 4'b0111;
            $display("Testcase %0d: Select a8 (choose=0111)", test_num);
            #1;

            check_outputs(a8);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            initialize_inputs();
            choose = 4'b1000;
            $display("Testcase %0d: Select a9 (choose=1000)", test_num);
            #1;

            check_outputs(a9);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            initialize_inputs();
            choose = 4'b1001;
            $display("Testcase %0d: Select a10 (choose=1001)", test_num);
            #1;

            check_outputs(a10);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            initialize_inputs();
            choose = 4'b1010;
            $display("Testcase %0d: Select a11 (choose=1010)", test_num);
            #1;

            check_outputs(a11);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            initialize_inputs();
            choose = 4'b1011;
            $display("Testcase %0d: Select a12 (choose=1011)", test_num);
            #1;

            check_outputs(a12);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            initialize_inputs();
            choose = 4'b1100;
            $display("Testcase %0d: Select a13 (choose=1100)", test_num);
            #1;

            check_outputs(a13);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            initialize_inputs();
            choose = 4'b1101;
            $display("Testcase %0d: Invalid selection (choose=1101), expect X", test_num);
            #1;

            check_outputs(32'hxxxx_xxxx);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            initialize_inputs();
            choose = 4'b1110;
            $display("Testcase %0d: Invalid selection (choose=1110), expect X", test_num);
            #1;

            check_outputs(32'hxxxx_xxxx);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            initialize_inputs();
            choose = 4'b1111;
            $display("Testcase %0d: Invalid selection (choose=1111), expect X", test_num);
            #1;

            check_outputs(32'hxxxx_xxxx);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [31:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
