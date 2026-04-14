`timescale 1ns/1ps

module RsDecodeDpRam_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [8:0] data;
    reg [8:0] rdaddress;
    reg rden;
    reg [8:0] wraddress;
    reg wren;
    wire [8:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RsDecodeDpRam dut (
        .clock(clock),
        .data(data),
        .rdaddress(rdaddress),
        .rden(rden),
        .wraddress(wraddress),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            data = 9'h000;
            rdaddress = 9'h000;
            wraddress = 9'h000;
            rden = 0;
            wren = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge clock);
            wraddress = 9'h010;
            data = 9'h1A5;
            wren = 1;
            @(posedge clock);
            wren = 0;


            @(posedge clock);
            rdaddress = 9'h010;
            rden = 1;
            @(posedge clock);
            #1;

            $display("Testcase %0d: Basic Write and Read", test_num);
            #1;

            check_outputs(9'h1A5);
            rden = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge clock);
            wraddress = 9'h020;
            data = 9'h0FF;
            wren = 0;
            @(posedge clock);


            @(posedge clock);
            rdaddress = 9'h020;
            rden = 1;
            @(posedge clock);
            #1;

            $display("Testcase %0d: Write Enable Check (Expect 0 or previous)", test_num);
            #1;

            check_outputs(9'h000);
            rden = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clock);
            wraddress = 9'h030;
            data = 9'h0AA;
            wren = 1;
            @(posedge clock);
            wren = 0;


            @(posedge clock);
            wraddress = 9'h040;
            data = 9'h1BB;
            wren = 1;
            rdaddress = 9'h030;
            rden = 1;

            @(posedge clock);
            #1;

            $display("Testcase %0d: Simultaneous Read/Write (Diff Addr)", test_num);
            #1;

            check_outputs(9'h0AA);
            wren = 0;
            rden = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge clock);
            wraddress = 9'h1FF;
            data = 9'h1FF;
            wren = 1;
            @(posedge clock);
            wren = 0;


            @(posedge clock);
            rdaddress = 9'h1FF;
            rden = 1;
            @(posedge clock);
            #1;

            $display("Testcase %0d: High Address Check (0x1FF)", test_num);
            #1;

            check_outputs(9'h1FF);
            rden = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(posedge clock);
            wraddress = 9'h050;
            data = 9'h055;
            wren = 1;
            @(posedge clock);
            wren = 0;


            @(posedge clock);
            rdaddress = 9'h050;
            rden = 1;
            @(posedge clock);


            @(posedge clock);
            rdaddress = 9'h010;
            rden = 0;
            @(posedge clock);
            #1;

            $display("Testcase %0d: Read Enable Check", test_num);


            #1;



            check_outputs(9'h055);
        end
        endtask

    task testcase006;

        reg [8:0] i;
        begin
            test_num = 6;
            reset_dut();

            for(i=0; i<5; i=i+1) begin
                @(posedge clock);
                wraddress = i;
                data = i + 9'h100;
                wren = 1;
            end
            @(posedge clock);
            wren = 0;


            @(posedge clock);
            rdaddress = 9'h004;
            rden = 1;
            @(posedge clock);
            #1;

            $display("Testcase %0d: Data Integrity (Index 4)", test_num);
            #1;

            check_outputs(9'h104);
            rden = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RsDecodeDpRam Testbench");
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
        input [8:0] expected_q;
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
        $dumpvars(0,clock, data, rdaddress, rden, wraddress, wren, q);
    end

endmodule
