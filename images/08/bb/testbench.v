`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] internal_ip;
    reg reset;
    wire [31:0] external_ip;
    wire [7:0] translation_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .internal_ip(internal_ip),
        .reset(reset),
        .external_ip(external_ip),
        .translation_count(translation_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            internal_ip = 32'h0;
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
            $display("\nTestcase %03d: Single Translation", test_num);
            reset_dut();

            internal_ip = 32'hC0A8010A;
            @(posedge clk);
            #1;
            internal_ip = 32'h0;


            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hC0A80001, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multiple Sequential Translations", test_num);
            reset_dut();


            internal_ip = 32'hC0A8010B;
            @(posedge clk);
            #1;

            internal_ip = 32'hC0A8010C;
            @(posedge clk);
            #1;

            internal_ip = 32'hC0A8010D;
            @(posedge clk);
            #1;

            internal_ip = 32'h0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hC0A80001, 8'h03);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Counter Persistence/No Traffic", test_num);
            reset_dut();


            internal_ip = 32'h0A000005;
            @(posedge clk);
            #1;


            internal_ip = 32'h0;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(32'hC0A80001, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset Functionality", test_num);
            reset_dut();


            repeat(5) begin
                internal_ip = 32'hC0A801FF;
                @(posedge clk);
                #1;
            end


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h00000000, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Rapid Burst Translation", test_num);
            reset_dut();

            repeat(10) begin
                internal_ip = 32'hAC100001;
                @(posedge clk);
                #1;
            end

            internal_ip = 32'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hC0A80001, 8'h0A);
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
        input [31:0] expected_external_ip;
        input [7:0] expected_translation_count;
        begin
            if (expected_external_ip === (expected_external_ip ^ external_ip ^ expected_external_ip) &&
                expected_translation_count === (expected_translation_count ^ translation_count ^ expected_translation_count)) begin
                $display("PASS");
                $display("  Outputs: external_ip=%h, translation_count=%h",
                         external_ip, translation_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: external_ip=%h, translation_count=%h",
                         expected_external_ip, expected_translation_count);
                $display("  Got:      external_ip=%h, translation_count=%h",
                         external_ip, translation_count);
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
        $dumpvars(0,clk, internal_ip, reset, external_ip, translation_count);
    end

endmodule
