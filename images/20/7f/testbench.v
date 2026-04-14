`timescale 1ns/1ps

module MMU_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [31:0] v_addr;
    reg valid;
    wire [31:0] p_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MMU dut (
        .clk(clk),
        .rst(rst),
        .v_addr(v_addr),
        .valid(valid),
        .p_addr(p_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            v_addr = 0;
            valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Valid translation at address 0x00000000", test_num);
            v_addr = 32'h00000000;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00001000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Valid translation at address 0x00000FFF", test_num);
            v_addr = 32'h00000FFF;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00001FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Translation with valid=0 (expect 0)", test_num);
            v_addr = 32'h00000500;
            valid = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Invalid Virtual Page (VPN=1)", test_num);
            v_addr = 32'h00001000;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Translation with arbitrary offset 0xA2C", test_num);
            v_addr = 32'h00000A2C;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00001A2C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MMU Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_p_addr;
        begin
            if (expected_p_addr === (expected_p_addr ^ p_addr ^ expected_p_addr)) begin
                $display("PASS");
                $display("  Outputs: p_addr=%h",
                         p_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_addr=%h",
                         expected_p_addr);
                $display("  Got:      p_addr=%h",
                         p_addr);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, rst, v_addr, valid, p_addr);
    end

endmodule
