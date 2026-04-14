`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg [180:0] data;
    reg rdclk;
    reg rdreq;
    reg wrclk;
    reg wrreq;
    wire [180:0] q;
    wire rdempty;
    wire wrempty;
    wire [6:0] wrusedw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclr(aclr),
        .data(data),
        .rdclk(rdclk),
        .rdreq(rdreq),
        .wrclk(wrclk),
        .wrreq(wrreq),
        .q(q),
        .rdempty(rdempty),
        .wrempty(wrempty),
        .wrusedw(wrusedw)
    );

    // Clock generation (10ns period)
    initial begin
        rdclk = 0;
        forever #5 rdclk = ~rdclk;
    end

        task reset_dut;

        begin
            aclr = 1;
            data = 0;
            rdreq = 0;
            wrreq = 0;
            #20;
            aclr = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(181'hx, 1'b1, 1'b1, 7'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge wrclk);
            wrreq = 1;
            data = 181'h123456789ABCDEF0123456789ABCDEF0123456789A;
            @(posedge wrclk);
            wrreq = 0;


            repeat(10) @(posedge rdclk);


            @(posedge rdclk);
            rdreq = 1;
            @(posedge rdclk);
            rdreq = 0;


            #1;



            check_outputs(181'h123456789ABCDEF0123456789ABCDEF0123456789A, 1'b1, 1'b1, 7'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            for(i=0; i<64; i=i+1) begin
                @(posedge wrclk);
                wrreq = 1;
                data = i;
                @(posedge wrclk);
                wrreq = 0;
            end


            repeat(10) @(posedge wrclk);



            #1;




            check_outputs(181'hx, 1'b0, 1'b0, 7'h40);
        end
        endtask

    task testcase004;

        reg [180:0] last_val;
        begin
            test_num = 4;
            reset_dut();


            for(i=0; i<127; i=i+1) begin
                @(posedge wrclk);
                wrreq = 1;
                data = i;
            end
            @(posedge wrclk);
            wrreq = 0;

            repeat(10) @(posedge rdclk);


            for(i=0; i<127; i=i+1) begin
                @(posedge rdclk);
                rdreq = 1;
                last_val = q;
            end
            @(posedge rdclk);
            rdreq = 0;

            repeat(5) @(posedge rdclk);

            #1;


            check_outputs(126, 1'b1, 1'b1, 7'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            for(i=0; i<5; i=i+1) begin
                @(posedge wrclk);
                wrreq = 1;
                data = i + 100;
            end
            @(posedge wrclk);
            wrreq = 0;

            repeat(5) @(posedge wrclk);


            fork
                begin
                    @(posedge wrclk);
                    wrreq = 1;
                    data = 181'hFFFF;
                    @(posedge wrclk);
                    wrreq = 0;
                end
                begin
                    @(posedge rdclk);
                    rdreq = 1;
                    @(posedge rdclk);
                    rdreq = 0;
                end
            join

            repeat(10) @(posedge wrclk);

            #1;


            check_outputs(100, 1'b0, 1'b0, 7'h5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [180:0] expected_q;
        input expected_rdempty;
        input expected_wrempty;
        input [6:0] expected_wrusedw;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_rdempty === (expected_rdempty ^ rdempty ^ expected_rdempty) &&
                expected_wrempty === (expected_wrempty ^ wrempty ^ expected_wrempty) &&
                expected_wrusedw === (expected_wrusedw ^ wrusedw ^ expected_wrusedw)) begin
                $display("PASS");
                $display("  Outputs: q=%h, rdempty=%b, wrempty=%b, wrusedw=%h",
                         q, rdempty, wrempty, wrusedw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, rdempty=%b, wrempty=%b, wrusedw=%h",
                         expected_q, expected_rdempty, expected_wrempty, expected_wrusedw);
                $display("  Got:      q=%h, rdempty=%b, wrempty=%b, wrusedw=%h",
                         q, rdempty, wrempty, wrusedw);
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
        $dumpvars(0,aclr, data, rdclk, rdreq, wrclk, wrreq, q, rdempty, wrempty, wrusedw);
    end

endmodule
