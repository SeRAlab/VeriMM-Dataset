`timescale 1ns/1ps

module soc_design_SystemID_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clock;
    reg reset_n;
    wire [31:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    soc_design_SystemID dut (
        .address(address),
        .clock(clock),
        .reset_n(reset_n),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset_n = 0;
        address = 32'h0;
        @(posedge clock);
        #1;
        reset_n = 1;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Address 32'h0", test_num);
        reset_dut();
        address = 32'h0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Address 32'h4", test_num);
        reset_dut();
        address = 32'h4;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Invalid Address 32'h8", test_num);
        reset_dut();
        address = 32'h8;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Invalid Address 32'hFFFFFFFF", test_num);
        reset_dut();
        address = 32'hFFFFFFFF;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Read 0x0 then 0x4", test_num);
        reset_dut();
        address = 32'h0;
        @(posedge clock);
        #1;
        address = 32'h4;
        @(posedge clock);
        #1;

        #1;


        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Read 0x4 then Invalid", test_num);
        reset_dut();
        address = 32'h4;
        @(posedge clock);
        #1;
        address = 32'h100;
        @(posedge clock);
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
        $display("soc_design_SystemID Testbench");
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
        input [31:0] expected_readdata;
        begin
            if (expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: readdata=%h",
                         readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readdata=%h",
                         expected_readdata);
                $display("  Got:      readdata=%h",
                         readdata);
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
        $dumpvars(0,address, clock, reset_n, readdata);
    end

endmodule
