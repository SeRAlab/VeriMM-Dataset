`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg M_AXIS_TREADY;
    reg [7:0] data;
    reg href;
    reg pclk;
    reg vsync;
    wire [31:0] M_AXIS_TDATA;
    wire M_AXIS_TLAST;
    wire M_AXIS_TUSER;
    wire M_AXIS_TVALID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M_AXIS_TREADY(M_AXIS_TREADY),
        .data(data),
        .href(href),
        .pclk(pclk),
        .vsync(vsync),
        .M_AXIS_TDATA(M_AXIS_TDATA),
        .M_AXIS_TLAST(M_AXIS_TLAST),
        .M_AXIS_TUSER(M_AXIS_TUSER),
        .M_AXIS_TVALID(M_AXIS_TVALID)
    );

    // Clock generation (10ns period)
    initial begin
        pclk = 0;
        forever #5 pclk = ~pclk;
    end

        task reset_dut;

        begin

            vsync = 1;
            href = 0;
            data = 8'h00;
            M_AXIS_TREADY = 1;
            repeat(5) @(posedge pclk);
            vsync = 0;
            repeat(5) @(posedge pclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Start of Frame (TUSER Check)");
            reset_dut();


            @(posedge pclk);
            href = 1;


            data = 8'h11; @(posedge pclk);
            data = 8'h22; @(posedge pclk);
            data = 8'h33; @(posedge pclk);

            href = 0;



            #1;




            check_outputs(32'h00332211, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Running Testcase 002: End of Line (TLAST Check)");
            reset_dut();

            @(posedge pclk);
            href = 1;


            for (i = 0; i < 639; i = i + 1) begin
                data = 8'hAA; @(posedge pclk);
                data = 8'hBB; @(posedge pclk);
                data = 8'hCC; @(posedge pclk);
            end


            data = 8'hD1; @(posedge pclk);
            data = 8'hD2; @(posedge pclk);
            data = 8'hD3; @(posedge pclk);

            href = 0;

            #1;


            check_outputs(32'h00D3D2D1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Intermediate Pixel Check");
            reset_dut();

            @(posedge pclk);
            href = 1;


            data = 8'h01; @(posedge pclk);
            data = 8'h02; @(posedge pclk);
            data = 8'h03; @(posedge pclk);


            data = 8'hA1; @(posedge pclk);
            data = 8'hA2; @(posedge pclk);
            data = 8'hA3; @(posedge pclk);

            href = 0;

            #1;


            check_outputs(32'h00A3A2A1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Multi-frame Sync Check");
            reset_dut();


            href = 1;
            data = 8'h11; @(posedge pclk);
            data = 8'h11; @(posedge pclk);
            data = 8'h11; @(posedge pclk);
            href = 0;


            vsync = 1; @(posedge pclk);
            vsync = 0; @(posedge pclk);

            href = 1;

            data = 8'hF1; @(posedge pclk);
            data = 8'hF2; @(posedge pclk);
            data = 8'hF3; @(posedge pclk);
            href = 0;


            #1;



            check_outputs(32'h00F3F2F1, 1'b0, 1'b1, 1'b1);
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
        input [31:0] expected_M_AXIS_TDATA;
        input expected_M_AXIS_TLAST;
        input expected_M_AXIS_TUSER;
        input expected_M_AXIS_TVALID;
        begin
            if (expected_M_AXIS_TDATA === (expected_M_AXIS_TDATA ^ M_AXIS_TDATA ^ expected_M_AXIS_TDATA) &&
                expected_M_AXIS_TLAST === (expected_M_AXIS_TLAST ^ M_AXIS_TLAST ^ expected_M_AXIS_TLAST) &&
                expected_M_AXIS_TUSER === (expected_M_AXIS_TUSER ^ M_AXIS_TUSER ^ expected_M_AXIS_TUSER) &&
                expected_M_AXIS_TVALID === (expected_M_AXIS_TVALID ^ M_AXIS_TVALID ^ expected_M_AXIS_TVALID)) begin
                $display("PASS");
                $display("  Outputs: M_AXIS_TDATA=%h, M_AXIS_TLAST=%b, M_AXIS_TUSER=%b, M_AXIS_TVALID=%b",
                         M_AXIS_TDATA, M_AXIS_TLAST, M_AXIS_TUSER, M_AXIS_TVALID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M_AXIS_TDATA=%h, M_AXIS_TLAST=%b, M_AXIS_TUSER=%b, M_AXIS_TVALID=%b",
                         expected_M_AXIS_TDATA, expected_M_AXIS_TLAST, expected_M_AXIS_TUSER, expected_M_AXIS_TVALID);
                $display("  Got:      M_AXIS_TDATA=%h, M_AXIS_TLAST=%b, M_AXIS_TUSER=%b, M_AXIS_TVALID=%b",
                         M_AXIS_TDATA, M_AXIS_TLAST, M_AXIS_TUSER, M_AXIS_TVALID);
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
        $dumpvars(0,M_AXIS_TREADY, data, href, pclk, vsync, M_AXIS_TDATA, M_AXIS_TLAST, M_AXIS_TUSER, M_AXIS_TVALID);
    end

endmodule
