`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] alu_out;
    reg [1:0] m3;
    reg [15:0] pc_p1;
    reg [15:0] shift_out;
    wire [15:0] mem_frwd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_out(alu_out),
        .m3(m3),
        .pc_p1(pc_p1),
        .shift_out(shift_out),
        .mem_frwd_data(mem_frwd_data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Forwarding ALU_OUT (m3=01)", test_num);
            m3 = 2'b01;
            alu_out = 16'hA5A5;
            shift_out = 16'h1234;
            pc_p1 = 16'hFFFF;
            #10;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Forwarding SHIFT_OUT (m3=10)", test_num);
            m3 = 2'b10;
            alu_out = 16'h0000;
            shift_out = 16'h5A5A;
            pc_p1 = 16'hBEEF;
            #10;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Forwarding PC_P1 (m3=11)", test_num);
            m3 = 2'b11;
            alu_out = 16'hDEAD;
            shift_out = 16'hC0DE;
            pc_p1 = 16'h1337;
            #10;
            #1;

            check_outputs(16'h1337);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Boundary Check - All Zeros on ALU (m3=01)", test_num);
            m3 = 2'b01;
            alu_out = 16'h0000;
            shift_out = 16'hFFFF;
            pc_p1 = 16'hFFFF;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary Check - All Ones on Shift (m3=10)", test_num);
            m3 = 2'b10;
            alu_out = 16'h0000;
            shift_out = 16'hFFFF;
            pc_p1 = 16'h0000;
            #10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Rapid Switching and Data Stability", test_num);

            alu_out = 16'h1111;
            shift_out = 16'h2222;
            pc_p1 = 16'h3333;


            m3 = 2'b11;
            #5;

            m3 = 2'b01;
            #5;
            #1;

            check_outputs(16'h1111);
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
        input [15:0] expected_mem_frwd_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_frwd_data === (expected_mem_frwd_data ^ mem_frwd_data ^ expected_mem_frwd_data)) begin
                $display("PASS");
                $display("  Outputs: mem_frwd_data=%h",
                         mem_frwd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_frwd_data=%h",
                         expected_mem_frwd_data);
                $display("  Got:      mem_frwd_data=%h",
                         mem_frwd_data);
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
