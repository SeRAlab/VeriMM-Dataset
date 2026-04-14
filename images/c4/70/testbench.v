`timescale 1ns/1ps

module ram_model_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] data;
    reg [23:0] rdaddress;
    reg [23:0] wraddress;
    reg wrclock;
    reg wren;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_model dut (
        .data(data),
        .rdaddress(rdaddress),
        .wraddress(wraddress),
        .wrclock(wrclock),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        wrclock = 0;
        forever #5 wrclock = ~wrclock;
    end

        task reset_dut;

        begin
            data = 0;
            rdaddress = 0;
            wraddress = 0;
            wren = 0;
            @(posedge wrclock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read at Address 0", test_num);
            reset_dut();


            wren = 1;
            wraddress = 24'd0;
            data = 32'hACE1ACE1;
            @(posedge wrclock);
            #2;


            wren = 0;
            rdaddress = 24'd0;
            @(posedge wrclock);
            #2;

            #1;


            check_outputs(32'hACE1ACE1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address (2047) Write/Read", test_num);
            reset_dut();


            wren = 1;
            wraddress = 24'd2047;
            data = 32'h12345678;
            @(posedge wrclock);
            #2;


            wren = 0;
            rdaddress = 24'd2047;
            @(posedge wrclock);
            #2;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Write Enable functionality", test_num);
            reset_dut();


            wren = 0;
            wraddress = 24'd10;
            data = 32'hBAD0BAD0;
            @(posedge wrclock);
            #2;


            rdaddress = 24'd10;
            @(posedge wrclock);
            #2;


            if (q === 32'hBAD0BAD0) begin
                $display("FAIL: Data written while wren was low");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Data was not written while wren was low");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read from Invalid Address (2048)", test_num);
            reset_dut();


            rdaddress = 24'd2048;
            @(posedge wrclock);
            #2;

            #1;


            check_outputs(32'hXXXXXXXX);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Writes and Reads", test_num);
            reset_dut();


            wren = 1; wraddress = 24'd100; data = 32'hAAAAAAAA;
            @(posedge wrclock); #2;


            wren = 1; wraddress = 24'd101; data = 32'h55555555;
            @(posedge wrclock); #2;


            wren = 0; rdaddress = 24'd100;
            @(posedge wrclock); #2;
            if (q === 32'hAAAAAAAA) begin

                rdaddress = 24'd101;
                @(posedge wrclock); #2;
                #1;

                check_outputs(32'h55555555);
            end else begin
                #1;

                check_outputs(32'hAAAAAAAA);
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Write and Read", test_num);
            reset_dut();


            wren = 1; wraddress = 24'd50; data = 32'hCAFEBABE;
            @(posedge wrclock); #2;


            wren = 1;
            wraddress = 24'd60;
            data = 32'hFEEDFACE;
            rdaddress = 24'd50;
            @(posedge wrclock);
            #2;


            #1;



            check_outputs(32'hCAFEBABE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_model Testbench");
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
        input [31:0] expected_q;
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
        $dumpvars(0,data, rdaddress, wraddress, wrclock, wren, q);
    end

endmodule
