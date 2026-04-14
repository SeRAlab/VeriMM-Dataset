`timescale 1ns/1ps

module NAT_tb;

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
    NAT dut (
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
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: 192.168.1.10:8080 -> 10.0.0.1:10000", test_num);
            ip_in = {8'd192, 8'd168, 8'd1, 8'd10};
            port_in = 16'd8080;
            @(posedge clk);
            #1;
            #1;

            check_outputs({8'd10, 8'd0, 8'd0, 8'd1}, 16'd10000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: 192.168.1.20:8081 -> 10.0.0.2:10001", test_num);
            ip_in = {8'd192, 8'd168, 8'd1, 8'd20};
            port_in = 16'd8081;
            @(posedge clk);
            #1;
            #1;

            check_outputs({8'd10, 8'd0, 8'd0, 8'd2}, 16'd10001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: 192.168.1.30:8082 -> 10.0.0.3:10002", test_num);
            ip_in = {8'd192, 8'd168, 8'd1, 8'd30};
            port_in = 16'd8082;
            @(posedge clk);
            #1;
            #1;

            check_outputs({8'd10, 8'd0, 8'd0, 8'd3}, 16'd10002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Passthrough for unmapped IP (172.16.0.1)", test_num);
            ip_in = {8'd172, 8'd16, 8'd0, 8'd1};
            port_in = 16'd8080;
            @(posedge clk);
            #1;
            #1;

            check_outputs({8'd172, 8'd16, 8'd0, 8'd1}, 16'd8080);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Passthrough for mapped IP with wrong port (192.168.1.10:9000)", test_num);
            ip_in = {8'd192, 8'd168, 8'd1, 8'd10};
            port_in = 16'd9000;
            @(posedge clk);
            #1;
            #1;

            check_outputs({8'd192, 8'd168, 8'd1, 8'd10}, 16'd9000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Passthrough for mapped port with wrong IP (10.10.10.10:8081)", test_num);
            ip_in = {8'd10, 8'd10, 8'd10, 8'd10};
            port_in = 16'd8081;
            @(posedge clk);
            #1;
            #1;

            check_outputs({8'd10, 8'd10, 8'd10, 8'd10}, 16'd8081);
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
