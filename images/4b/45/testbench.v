`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALU3;
    reg [5:0] C3;
    reg [10:0] DATA_ADDR_3;
    reg [1:0] M3;
    reg [1:0] SH3;
    reg [6:0] T3;
    reg clock;
    wire [3:0] ALU4;
    wire [5:0] C4;
    wire [10:0] DATA_ADDR_4;
    wire [1:0] M4;
    wire [1:0] SH4;
    wire [6:0] T4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU3(ALU3),
        .C3(C3),
        .DATA_ADDR_3(DATA_ADDR_3),
        .M3(M3),
        .SH3(SH3),
        .T3(T3),
        .clock(clock),
        .ALU4(ALU4),
        .C4(C4),
        .DATA_ADDR_4(DATA_ADDR_4),
        .M4(M4),
        .SH4(SH4),
        .T4(T4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Passthrough", test_num);

            ALU3 = 4'b0000;
            C3 = 6'b000000;
            DATA_ADDR_3 = 11'b00000000000;
            M3 = 2'b00;
            SH3 = 2'b00;
            T3 = 7'b0000000;


            #1;



            check_outputs(4'h0, 6'h00, 11'h000, 2'b00, 2'b00, 7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Passthrough", test_num);

            ALU3 = 4'hF;
            C3 = 6'h3F;
            DATA_ADDR_3 = 11'h7FF;
            M3 = 2'b11;
            SH3 = 2'b11;
            T3 = 7'h7F;


            #1;



            check_outputs(4'hF, 6'h3F, 11'h7FF, 2'b11, 2'b11, 7'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Pattern A", test_num);

            ALU3 = 4'hA;
            C3 = 6'h2A;
            DATA_ADDR_3 = 11'h555;
            M3 = 2'b10;
            SH3 = 2'b01;
            T3 = 7'h55;


            #1;



            check_outputs(4'hA, 6'h2A, 11'h555, 2'b10, 2'b01, 7'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Pattern B", test_num);

            ALU3 = 4'h5;
            C3 = 6'h15;
            DATA_ADDR_3 = 11'h2AA;
            M3 = 2'b01;
            SH3 = 2'b10;
            T3 = 7'h2A;


            #1;



            check_outputs(4'h5, 6'h15, 11'h2AA, 2'b01, 2'b10, 7'h2A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Boundary Values", test_num);

            ALU3 = 4'h7;
            C3 = 6'h1F;
            DATA_ADDR_3 = 11'h400;
            M3 = 2'b11;
            SH3 = 2'b00;
            T3 = 7'h0F;


            #1;



            check_outputs(4'h7, 6'h1F, 11'h400, 2'b11, 2'b00, 7'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB Only", test_num);

            ALU3 = 4'h8;
            C3 = 6'h20;
            DATA_ADDR_3 = 11'h400;
            M3 = 2'b10;
            SH3 = 2'b10;
            T3 = 7'h40;


            #1;



            check_outputs(4'h8, 6'h20, 11'h400, 2'b10, 2'b10, 7'h40);
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
        input [3:0] expected_ALU4;
        input [5:0] expected_C4;
        input [10:0] expected_DATA_ADDR_4;
        input [1:0] expected_M4;
        input [1:0] expected_SH4;
        input [6:0] expected_T4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU4 === (expected_ALU4 ^ ALU4 ^ expected_ALU4) &&
                expected_C4 === (expected_C4 ^ C4 ^ expected_C4) &&
                expected_DATA_ADDR_4 === (expected_DATA_ADDR_4 ^ DATA_ADDR_4 ^ expected_DATA_ADDR_4) &&
                expected_M4 === (expected_M4 ^ M4 ^ expected_M4) &&
                expected_SH4 === (expected_SH4 ^ SH4 ^ expected_SH4) &&
                expected_T4 === (expected_T4 ^ T4 ^ expected_T4)) begin
                $display("PASS");
                $display("  Outputs: ALU4=%h, C4=%h, DATA_ADDR_4=%h, M4=%h, SH4=%h, T4=%h",
                         ALU4, C4, DATA_ADDR_4, M4, SH4, T4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU4=%h, C4=%h, DATA_ADDR_4=%h, M4=%h, SH4=%h, T4=%h",
                         expected_ALU4, expected_C4, expected_DATA_ADDR_4, expected_M4, expected_SH4, expected_T4);
                $display("  Got:      ALU4=%h, C4=%h, DATA_ADDR_4=%h, M4=%h, SH4=%h, T4=%h",
                         ALU4, C4, DATA_ADDR_4, M4, SH4, T4);
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
