`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dest_ip;
    reg rst;
    reg [31:0] src_ip;
    wire [31:0] translated_src_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .dest_ip(dest_ip),
        .rst(rst),
        .src_ip(src_ip),
        .translated_src_ip(translated_src_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            src_ip = 32'h0;
            dest_ip = 32'h0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Private IP Lower Bound (192.168.0.0)", test_num);
            src_ip = 32'hC0A80000;
            dest_ip = 32'h08080808;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Private IP Upper Bound (192.168.255.255)", test_num);
            src_ip = 32'hC0A8FFFF;
            dest_ip = 32'h01010101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Private IP Middle Range (192.168.1.50)", test_num);
            src_ip = 32'hC0A80132;
            dest_ip = 32'hD83AD38E;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Public IP just below private range (192.167.255.255)", test_num);
            src_ip = 32'hC0A7FFFF;
            dest_ip = 32'h08080808;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A7FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Public IP just above private range (192.169.0.0)", test_num);
            src_ip = 32'hC0A90000;
            dest_ip = 32'h08080808;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A90000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Global Public IP (8.8.8.8)", test_num);
            src_ip = 32'h08080808;
            dest_ip = 32'hC0A80001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h08080808);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Private IP with different Dest IP", test_num);
            src_ip = 32'hC0A80A0A;
            dest_ip = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: IP 0.0.0.0 Check", test_num);
            src_ip = 32'h00000000;
            dest_ip = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT Testbench");
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
        input [31:0] expected_translated_src_ip;
        begin
            if (expected_translated_src_ip === (expected_translated_src_ip ^ translated_src_ip ^ expected_translated_src_ip)) begin
                $display("PASS");
                $display("  Outputs: translated_src_ip=%h",
                         translated_src_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: translated_src_ip=%h",
                         expected_translated_src_ip);
                $display("  Got:      translated_src_ip=%h",
                         translated_src_ip);
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
        $dumpvars(0,clk, dest_ip, rst, src_ip, translated_src_ip);
    end

endmodule
