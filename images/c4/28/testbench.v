`timescale 1ns/1ps

module memory_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] data;
    reg [25:0] rdaddress;
    reg rdclken;
    reg [25:0] wraddress;
    reg wrclock;
    reg wren;
    wire [63:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory dut (
        .data(data),
        .rdaddress(rdaddress),
        .rdclken(rdclken),
        .wraddress(wraddress),
        .wrclock(wrclock),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        rdclken = 0;
        forever #5 rdclken = ~rdclken;
    end

        task reset_dut;

        begin
            data = 64'd0;
            rdaddress = 26'd0;
            wraddress = 26'd0;
            wrclock = 0;
            wren = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(negedge rdclken);
            wren = 1;
            wraddress = 26'h0;
            data = 64'hFEDCBA9876543210;
            #5 wrclock = 1; #10 wrclock = 0;
            wren = 0;


            rdaddress = 26'h0;
            repeat(2) @(posedge rdclken);
            #1;

            $display("Testcase %0d: Basic Write/Read at Address 0", test_num);
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(negedge rdclken);
            wren = 1;
            wraddress = 26'h3FFFFFF;
            data = 64'hA5A5A5A55A5A5A5A;
            #5 wrclock = 1; #10 wrclock = 0;
            wren = 0;


            rdaddress = 26'h3FFFFFF;
            repeat(2) @(posedge rdclken);
            #1;

            $display("Testcase %0d: Boundary Address Test (0x3FFFFFF)", test_num);
            #1;

            check_outputs(64'hA5A5A5A55A5A5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            wren = 1;
            wraddress = 26'h100;
            data = 64'h1234567890ABCDEF;
            #5 wrclock = 1; #10 wrclock = 0;


            wren = 0;
            wraddress = 26'h100;
            data = 64'hFFFFFFFFFFFFFFFF;
            #5 wrclock = 1; #10 wrclock = 0;


            rdaddress = 26'h100;
            repeat(2) @(posedge rdclken);
            #1;

            $display("Testcase %0d: Write Enable Verification", test_num);
            #1;

            check_outputs(64'h1234567890ABCDEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            wren = 1;
            wraddress = 26'hA;
            data = 64'hAAAA_AAAA_AAAA_AAAA;
            #5 wrclock = 1; #10 wrclock = 0;


            wraddress = 26'hB;
            data = 64'hBBBB_BBBB_BBBB_BBBB;
            #5 wrclock = 1; #10 wrclock = 0;
            wren = 0;


            rdaddress = 26'hA;
            repeat(2) @(posedge rdclken);
            #1;

            $display("Testcase %0d: Multiple Address Data Independence", test_num);
            #1;

            check_outputs(64'hAAAA_AAAA_AAAA_AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            wren = 1;
            wraddress = 26'h50;
            data = 64'h1111_1111_1111_1111;
            #5 wrclock = 1; #10 wrclock = 0;


            data = 64'h2222_2222_2222_2222;
            #5 wrclock = 1; #10 wrclock = 0;
            wren = 0;


            rdaddress = 26'h50;
            repeat(2) @(posedge rdclken);
            #1;

            $display("Testcase %0d: Read-Modify-Write (Overwriting)", test_num);
            #1;

            check_outputs(64'h2222_2222_2222_2222);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory Testbench");
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
        input [63:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,data, rdaddress, rdclken, wraddress, wrclock, wren, q);
    end

endmodule
