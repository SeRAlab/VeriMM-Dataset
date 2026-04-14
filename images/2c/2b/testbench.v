`timescale 1ns/1ps

module nat_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] private_ip;
    reg reset;
    reg valid;
    wire [31:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat dut (
        .clk(clk),
        .private_ip(private_ip),
        .reset(reset),
        .valid(valid),
        .public_ip(public_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            private_ip = 0;
            valid = 0;
            repeat (2) @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Translating 192.168.1.1", test_num);
            reset_dut();
            private_ip = 32'hC0A80101;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCB007101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Translating 10.0.0.1", test_num);
            reset_dut();
            private_ip = 32'h0A000001;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCB007102);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Translating 172.16.0.1", test_num);
            reset_dut();
            private_ip = 32'hAC100001;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCB007103);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Unmapped Private IP (8.8.8.8)", test_num);
            reset_dut();
            private_ip = 32'h08080808;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Valid signal LOW with 192.168.1.1", test_num);
            reset_dut();
            private_ip = 32'hC0A80101;
            valid = 0;
            @(posedge clk);
            #1;
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
        $display("nat Testbench");
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
        input [31:0] expected_public_ip;
        begin
            if (expected_public_ip === (expected_public_ip ^ public_ip ^ expected_public_ip)) begin
                $display("PASS");
                $display("  Outputs: public_ip=%h",
                         public_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: public_ip=%h",
                         expected_public_ip);
                $display("  Got:      public_ip=%h",
                         public_ip);
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
        $dumpvars(0,clk, private_ip, reset, valid, public_ip);
    end

endmodule
