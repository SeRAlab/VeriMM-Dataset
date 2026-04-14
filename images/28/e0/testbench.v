`timescale 1ns/1ps

module NAT_Translator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] internal_ip;
    reg request;
    reg reset;
    wire [7:0] external_ip;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT_Translator dut (
        .clk(clk),
        .internal_ip(internal_ip),
        .request(request),
        .reset(reset),
        .external_ip(external_ip),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request = 0;
            internal_ip = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Translation (Internal IP 0x0A)", test_num);

            internal_ip = 8'h0A;
            request = 1;
            @(posedge clk);
            #1;
            request = 0;


            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h6E, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Output Hold Capability", test_num);


            internal_ip = 8'h01;
            request = 1;
            @(posedge clk);
            #1;
            request = 0;
            @(posedge clk);
            #1;


            internal_ip = 8'hFF;
            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(8'h65, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Translations", test_num);


            internal_ip = 8'h05;
            request = 1;
            @(posedge clk);
            #1;
            request = 0;
            @(posedge clk);
            #1;


            internal_ip = 8'h14;
            request = 1;
            @(posedge clk);
            #1;
            request = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h78, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);

            internal_ip = 8'h20;
            request = 1;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: No Request Stability", test_num);

            internal_ip = 8'h55;
            request = 0;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT_Translator Testbench");
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
        input [7:0] expected_external_ip;
        input expected_ready;
        begin
            if (expected_external_ip === (expected_external_ip ^ external_ip ^ expected_external_ip) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: external_ip=%h, ready=%b",
                         external_ip, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: external_ip=%h, ready=%b",
                         expected_external_ip, expected_ready);
                $display("  Got:      external_ip=%h, ready=%b",
                         external_ip, ready);
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
        $dumpvars(0,clk, internal_ip, request, reset, external_ip, ready);
    end

endmodule
