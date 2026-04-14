`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dst_port;
    reg enable;
    reg rst;
    wire accepted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .clk(clk),
        .dst_port(dst_port),
        .enable(enable),
        .rst(rst),
        .accepted(accepted)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            dst_port = 0;
            enable = 0;
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
            $display("Testcase %03d: Port 80, Enable 1", test_num);
            reset_dut();
            dst_port = 16'd80;
            enable = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Port 443 (HTTPS), Enable 1", test_num);
            reset_dut();
            dst_port = 16'd443;
            enable = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Port 80, Enable 0", test_num);
            reset_dut();
            dst_port = 16'd80;
            enable = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Port 22 (SSH), Enable 1", test_num);
            reset_dut();
            dst_port = 16'd22;
            enable = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Port 8080, Enable 1", test_num);
            reset_dut();
            dst_port = 16'd8080;
            enable = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Port 80, Reset active", test_num);
            reset_dut();
            dst_port = 16'd80;
            enable = 1'b1;
            rst = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Toggle enable on Port 80", test_num);
            reset_dut();


            dst_port = 16'd80;
            enable = 1'b1;
            @(posedge clk);
            #1;


            enable = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_accepted;
        begin
            if (expected_accepted === (expected_accepted ^ accepted ^ expected_accepted)) begin
                $display("PASS");
                $display("  Outputs: accepted=%b",
                         accepted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accepted=%b",
                         expected_accepted);
                $display("  Got:      accepted=%b",
                         accepted);
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
        $dumpvars(0,clk, dst_port, enable, rst, accepted);
    end

endmodule
