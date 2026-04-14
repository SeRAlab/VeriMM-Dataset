`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] private_ip;
    reg reset;
    reg translate;
    wire [31:0] public_ip;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .private_ip(private_ip),
        .reset(reset),
        .translate(translate),
        .public_ip(public_ip),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            translate = 0;
            private_ip = 32'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic translation of 192.168.1.1", test_num);
            reset_dut();
            private_ip = 32'hC0A80101;
            translate = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(public_ip, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Translation of 10.0.0.5", test_num);
            reset_dut();
            private_ip = 32'h0A000005;
            translate = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(public_ip, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Translate signal is low", test_num);
            reset_dut();
            private_ip = 32'hC0A80101;
            translate = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Non-private IP (8.8.8.8)", test_num);
            reset_dut();
            private_ip = 32'h08080808;
            translate = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset mid-operation", test_num);
            reset_dut();
            private_ip = 32'hC0A80105;
            translate = 1;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 1'b0);
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
        input expected_valid;
        begin
            if (expected_public_ip === (expected_public_ip ^ public_ip ^ expected_public_ip) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: public_ip=%h, valid=%b",
                         public_ip, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: public_ip=%h, valid=%b",
                         expected_public_ip, expected_valid);
                $display("  Got:      public_ip=%h, valid=%b",
                         public_ip, valid);
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
        $dumpvars(0,clk, private_ip, reset, translate, public_ip, valid);
    end

endmodule
