`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] io_addr;
    reg io_addr_read;
    wire [15:0] d_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .io_addr(io_addr),
        .io_addr_read(io_addr_read),
        .d_addr(d_addr)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Disabled (Address 0)", test_num);
        io_addr_read = 1'b0;
        io_addr = 4'h0;
        #1;

        check_outputs(16'hzzzz);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 0)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'h0;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 1)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'h1;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 2)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'h2;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 3)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'h3;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 4)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'h4;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 5)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'h5;
        #1;

        check_outputs(16'h0020);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 6)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'h6;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 7)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'h7;
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 8)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'h8;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 9)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'h9;
        #1;

        check_outputs(16'h0200);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 10)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'hA;
        #1;

        check_outputs(16'h0400);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 11)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'hB;
        #1;

        check_outputs(16'h0800);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 12)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'hC;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 13)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'hD;
        #1;

        check_outputs(16'h2000);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 14)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'hE;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase017;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enabled (Address 15)", test_num);
        io_addr_read = 1'b1;
        io_addr = 4'hF;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase018;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Disabled (Address 15)", test_num);
        io_addr_read = 1'b0;
        io_addr = 4'hF;
        #1;

        check_outputs(16'hzzzz);
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
        testcase017();
        testcase018();
        
        
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
        input [15:0] expected_d_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_addr === (expected_d_addr ^ d_addr ^ expected_d_addr)) begin
                $display("PASS");
                $display("  Outputs: d_addr=%h",
                         d_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_addr=%h",
                         expected_d_addr);
                $display("  Got:      d_addr=%h",
                         d_addr);
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
