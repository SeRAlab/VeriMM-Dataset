`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] private_ip;
    reg rst;
    wire [31:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .private_ip(private_ip),
        .rst(rst),
        .public_ip(public_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            private_ip = 32'h0;
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
            $display("Test %0d: Testing Private IP 192.168.1.1 (Mapping Entry 1)", test_num);

            private_ip = 32'hC0A80101;
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
            $display("Test %0d: Testing Private IP 10.0.0.1 (Mapping Entry 3)", test_num);

            private_ip = 32'h0A000001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007103);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Testing Private IP 172.16.0.1 (Mapping Entry 5)", test_num);

            private_ip = 32'hAC100001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCB007105);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Testing Unregistered IP 8.8.8.8", test_num);
            private_ip = 32'h08080808;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Testing IP 0.0.0.0", test_num);
            private_ip = 32'h00000000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Testing output behavior during reset", test_num);
            rst = 1;
            private_ip = 32'hC0A80101;
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
        $display("NAT Testbench");
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
        $dumpvars(0,clk, private_ip, rst, public_ip);
    end

endmodule
