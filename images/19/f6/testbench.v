`timescale 1ns/1ps

module nat_translation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] ip_in;
    reg [15:0] port_in;
    reg reset;
    wire [31:0] ip_out;
    wire [15:0] port_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_translation dut (
        .clk(clk),
        .ip_in(ip_in),
        .port_in(port_in),
        .reset(reset),
        .ip_out(ip_out),
        .port_out(port_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ip_in = 32'b0;
            port_in = 16'b0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Translating Private IP 192.168.1.1", test_num);
            ip_in = 32'hC0A80101;
            port_in = 16'd80;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCB007101, 16'd81);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Passthrough for Public IP 8.8.8.8", test_num);
            ip_in = 32'h08080808;
            port_in = 16'd53;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h08080808, 16'd54);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Port Wrap-around (65535 + 1)", test_num);
            ip_in = 32'hC0A80101;
            port_in = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCB007101, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Non-matching Private IP 192.168.1.2", test_num);
            ip_in = 32'hC0A80102;
            port_in = 16'd443;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hC0A80102, 16'd444);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Zero Port Input", test_num);
            ip_in = 32'h01010101;
            port_in = 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h01010101, 16'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_translation Testbench");
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
        input [31:0] expected_ip_out;
        input [15:0] expected_port_out;
        begin
            if (expected_ip_out === (expected_ip_out ^ ip_out ^ expected_ip_out) &&
                expected_port_out === (expected_port_out ^ port_out ^ expected_port_out)) begin
                $display("PASS");
                $display("  Outputs: ip_out=%h, port_out=%h",
                         ip_out, port_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ip_out=%h, port_out=%h",
                         expected_ip_out, expected_port_out);
                $display("  Got:      ip_out=%h, port_out=%h",
                         ip_out, port_out);
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
        $dumpvars(0,clk, ip_in, port_in, reset, ip_out, port_out);
    end

endmodule
