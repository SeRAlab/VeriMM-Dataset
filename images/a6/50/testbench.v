`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] mem_ack;
    reg [3:0] mem_req;
    wire [3:0] mem_ack_out;
    wire [3:0] mem_req_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mem_ack(mem_ack),
        .mem_req(mem_req),
        .mem_ack_out(mem_ack_out),
        .mem_req_out(mem_req_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs zero", test_num);
            mem_req = 4'b0000;
            mem_ack = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Module 0 request", test_num);
            mem_req = 4'b0001;
            mem_ack = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Module 1 request", test_num);
            mem_req = 4'b0010;
            mem_ack = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Module 2 request", test_num);
            mem_req = 4'b0100;
            mem_ack = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Module 3 request", test_num);
            mem_req = 4'b1000;
            mem_ack = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Contention - Modules 0 and 1 (0 wins)", test_num);
            mem_req = 4'b0011;
            mem_ack = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Contention - Modules 1 and 2 (1 wins)", test_num);
            mem_req = 4'b0110;
            mem_ack = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Contention - All modules (0 wins)", test_num);
            mem_req = 4'b1111;
            mem_ack = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Module 0 request and acknowledgment", test_num);
            mem_req = 4'b0001;
            mem_ack = 4'b0001;
            #1;

            check_outputs(4'b0001, 4'b0001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Module 2 request and acknowledgment", test_num);
            mem_req = 4'b0100;
            mem_ack = 4'b0100;
            #1;

            check_outputs(4'b0100, 4'b0100);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Contention - Module 0 wins, Ack 1 ignored", test_num);
            mem_req = 4'b0011;
            mem_ack = 4'b0010;
            #1;

            check_outputs(4'b0000, 4'b0001);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: Contention - Module 0 wins and is acknowledged", test_num);
            mem_req = 4'b0011;
            mem_ack = 4'b0011;
            #1;

            check_outputs(4'b0001, 4'b0001);
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
        input [3:0] expected_mem_ack_out;
        input [3:0] expected_mem_req_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_ack_out === (expected_mem_ack_out ^ mem_ack_out ^ expected_mem_ack_out) &&
                expected_mem_req_out === (expected_mem_req_out ^ mem_req_out ^ expected_mem_req_out)) begin
                $display("PASS");
                $display("  Outputs: mem_ack_out=%h, mem_req_out=%h",
                         mem_ack_out, mem_req_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_ack_out=%h, mem_req_out=%h",
                         expected_mem_ack_out, expected_mem_req_out);
                $display("  Got:      mem_ack_out=%h, mem_req_out=%h",
                         mem_ack_out, mem_req_out);
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
