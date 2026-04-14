`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] addr;
    wire [1:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .data(data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reading Address 0x0", test_num);
        addr = 4'h0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Reading Address 0x1", test_num);
        addr = 4'h1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Reading Address 0x5", test_num);
        addr = 4'h5;
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Reading Address 0x8", test_num);
        addr = 4'h8;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Reading Address 0xA", test_num);
        addr = 4'hA;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Reading Address 0xE", test_num);
        addr = 4'hE;
        #1;

        check_outputs(8'h0E);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Reading Address 0xF (Maximum Depth)", test_num);
        addr = 4'hF;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Verifying all sequential addresses 0-15", test_num);
        for (integer i = 0; i < 16; i = i + 1) begin
            addr = i;
            #1;
            if (data !== i[7:0]) begin
                $display("  Sequential check failed at addr %h: Expected %h, Got %h", i, i[7:0], data);
                fail_count = fail_count + 1;
            end else begin
                pass_count = pass_count + 1;
            end
        end


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
        input [1:0] expected_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
