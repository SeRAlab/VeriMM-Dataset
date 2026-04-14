`timescale 1ns/1ps

module NATDevice_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mode;
    reg [31:0] private_ip;
    reg [31:0] public_ip;
    reg rst;
    wire [31:0] translated_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NATDevice dut (
        .clk(clk),
        .mode(mode),
        .private_ip(private_ip),
        .public_ip(public_ip),
        .rst(rst),
        .translated_ip(translated_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            mode = 0;
            private_ip = 0;
            public_ip = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Private to Public (Mode 0)", test_num);
            reset_dut();
            mode = 0;
            private_ip = 32'hC0A80101;
            public_ip  = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A80101 + 32'h01010101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Public to Private (Mode 1)", test_num);
            reset_dut();
            mode = 1;
            private_ip = 32'h00000000;
            public_ip  = 32'h08080808;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h08080808 - 32'h01010101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero IP Private to Public", test_num);
            reset_dut();
            mode = 0;
            private_ip = 32'h00000000;
            public_ip  = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000 + 32'h01010101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Max IP Public to Private (Wrap check)", test_num);
            reset_dut();
            mode = 1;
            private_ip = 32'h12345678;
            public_ip  = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF - 32'h01010101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset state check", test_num);

            mode = 0;
            private_ip = 32'hAAAAAAAA;

            rst = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00000000);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NATDevice Testbench");
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
        $dumpvars(0,clk, mode, private_ip, public_ip, rst, translated_ip);
    end

endmodule
