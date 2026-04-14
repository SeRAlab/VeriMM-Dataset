`timescale 1ns/1ps

module nat_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg [31:0] private_ip;
    reg [31:0] public_ip;
    wire [31:0] translated_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .private_ip(private_ip),
        .public_ip(public_ip),
        .translated_ip(translated_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ctrl = 0;
            private_ip = 32'b0;
            public_ip = 32'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Translation Off (Private IP Passthrough)", test_num);
            ctrl = 0;
            private_ip = 32'hC0A80101;
            public_ip  = 32'h08080808;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A80101);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Translation On (Public IP Output)", test_num);
            ctrl = 1;
            private_ip = 32'hC0A80101;
            public_ip  = 32'h08080808;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h08080808);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Boundary Check All Ones - Translation Off", test_num);
            ctrl = 0;
            private_ip = 32'hFFFFFFFF;
            public_ip  = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Boundary Check All Zeros - Translation On", test_num);
            ctrl = 1;
            private_ip = 32'hFFFFFFFF;
            public_ip  = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Stability Check - Verify Public IP change doesn't affect output when Ctrl=0", test_num);
            ctrl = 0;
            private_ip = 32'h0A000001;
            public_ip  = 32'h11223344;
            @(posedge clk);
            #1;
            public_ip = 32'hFFEECCBB;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0A000001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Stability Check - Verify Private IP change doesn't affect output when Ctrl=1", test_num);
            ctrl = 1;
            private_ip = 32'hC0A80A0A;
            public_ip  = 32'h40302010;
            @(posedge clk);
            #1;
            private_ip = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h40302010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_module Testbench");
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
        input [31:0] expected_translated_ip;
        begin
            if (expected_translated_ip === (expected_translated_ip ^ translated_ip ^ expected_translated_ip)) begin
                $display("PASS");
                $display("  Outputs: translated_ip=%h",
                         translated_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: translated_ip=%h",
                         expected_translated_ip);
                $display("  Got:      translated_ip=%h",
                         translated_ip);
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
        $dumpvars(0,clk, ctrl, private_ip, public_ip, translated_ip);
    end

endmodule
