`timescale 1ns/1ps

module nat_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    reg rst;
    reg set_external;
    reg set_internal;
    reg translate;
    wire [31:0] translated_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat dut (
        .clk(clk),
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .rst(rst),
        .set_external(set_external),
        .set_internal(set_internal),
        .translate(translate),
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
            set_external = 0;
            set_internal = 0;
            translate = 0;
            internal_ip = 32'h0;
            external_ip = 32'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Set and Translate", test_num);
            reset_dut();


            internal_ip = 32'hC0A8010A;
            set_internal = 1;
            @(posedge clk);
            #1 set_internal = 0;


            external_ip = 32'h08080808;
            set_external = 1;
            @(posedge clk);
            #1 set_external = 0;



            internal_ip = 32'hC0A8010A;
            translate = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h08080808);
            translate = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Functionality Check", test_num);
            reset_dut();


            translate = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
            translate = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Update/Overwrite IP Check", test_num);
            reset_dut();


            internal_ip = 32'h0A000001;
            set_internal = 1;
            @(posedge clk);
            #1 set_internal = 0;
            external_ip = 32'h01010101;
            set_external = 1;
            @(posedge clk);
            #1 set_external = 0;


            internal_ip = 32'hAC100001;
            set_internal = 1;
            @(posedge clk);
            #1 set_internal = 0;
            external_ip = 32'h04040404;
            set_external = 1;
            @(posedge clk);
            #1 set_external = 0;


            internal_ip = 32'hAC100001;
            translate = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h04040404);
            translate = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Translation Trigger Sensitivity", test_num);
            reset_dut();


            internal_ip = 32'hC0A80001;
            set_internal = 1;
            external_ip = 32'hD83AD38E;
            set_external = 1;
            @(posedge clk);
            #1;
            set_internal = 0;
            set_external = 0;


            translate = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values (All Fs)", test_num);
            reset_dut();

            internal_ip = 32'hFFFFFFFF;
            set_internal = 1;
            @(posedge clk);
            #1 set_internal = 0;

            external_ip = 32'hFFFFFFFF;
            set_external = 1;
            @(posedge clk);
            #1 set_external = 0;

            translate = 1;
            internal_ip = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF);
            translate = 0;
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
        $dumpvars(0,clk, external_ip, internal_ip, rst, set_external, set_internal, translate, translated_ip);
    end

endmodule
