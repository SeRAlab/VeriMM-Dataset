`timescale 1ns/1ps

module aeMB2_mult_tb;

    // Testbench signals (sequential circuit)
    reg dena;
    reg gclk;
    reg gpha;
    reg grst;
    reg [31:0] opa_of;
    reg [31:0] opb_of;
    reg [5:0] opc_of;
    wire [31:0] mul_mx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aeMB2_mult dut (
        .dena(dena),
        .gclk(gclk),
        .gpha(gpha),
        .grst(grst),
        .opa_of(opa_of),
        .opb_of(opb_of),
        .opc_of(opc_of),
        .mul_mx(mul_mx)
    );

    // Clock generation (10ns period)
    initial begin
        gclk = 0;
        forever #5 gclk = ~gclk;
    end

        task reset_dut;

        begin
            grst = 1;
            dena = 0;
            opa_of = 0;
            opb_of = 0;
            opc_of = 0;
            gpha = 0;
            repeat(2) @(posedge gclk);
            #1 grst = 0;
            @(posedge gclk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            opa_of = 32'd12;
            opb_of = 32'd5;
            dena = 1;
            @(posedge gclk);
            #1;
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            opa_of = 32'hABCDEFFF;
            opb_of = 32'd0;
            dena = 1;
            @(posedge gclk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            opa_of = 32'h5555AAAA;
            opb_of = 32'd1;
            dena = 1;
            @(posedge gclk);
            #1;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            opa_of = 32'hFFFFFFFF;
            opb_of = 32'd2;
            dena = 1;
            @(posedge gclk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            opa_of = 32'h00001234;
            opb_of = 32'h00005678;
            dena = 1;
            @(posedge gclk);
            #1;
            #1;

            check_outputs(32'h06260060);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            opa_of = 32'd50;
            opb_of = 32'd50;
            dena = 0;
            @(posedge gclk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            opa_of = 32'd10;
            opb_of = 32'd10;
            dena = 1;
            @(posedge gclk);
            #1;

            opa_of = 32'd7;
            opb_of = 32'd3;
            @(posedge gclk);
            #1;
            #1;

            check_outputs(32'd21);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aeMB2_mult Testbench");
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
        input [31:0] expected_mul_mx;
        begin
            if (expected_mul_mx === (expected_mul_mx ^ mul_mx ^ expected_mul_mx)) begin
                $display("PASS");
                $display("  Outputs: mul_mx=%h",
                         mul_mx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mul_mx=%h",
                         expected_mul_mx);
                $display("  Got:      mul_mx=%h",
                         mul_mx);
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
        $dumpvars(0,dena, gclk, gpha, grst, opa_of, opb_of, opc_of, mul_mx);
    end

endmodule
