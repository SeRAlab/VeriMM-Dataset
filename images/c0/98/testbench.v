`timescale 1ns/1ps

module SSPx_Slv_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] DO;
    reg MOSI;
    reg Rst;
    reg SCK;
    reg SSEL;
    wire [3:0] BC;
    wire [11:0] DI;
    wire EOC;
    wire En;
    wire MISO;
    wire [2:0] RA;
    wire WnR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SSPx_Slv dut (
        .DO(DO),
        .MOSI(MOSI),
        .Rst(Rst),
        .SCK(SCK),
        .SSEL(SSEL),
        .BC(BC),
        .DI(DI),
        .EOC(EOC),
        .En(En),
        .MISO(MISO),
        .RA(RA),
        .WnR(WnR)
    );

    // Clock generation (10ns period)
    initial begin
        Rst = 0;
        forever #5 Rst = ~Rst;
    end

        task reset_dut;

        begin
            Rst = 1;
            SSEL = 1;
            SCK = 0;
            MOSI = 0;
            DO = 12'h000;
            #20;
            Rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            DO = 12'h000;
            spi_transaction(16'hBA5A);



            #1;




            check_outputs(4'd0, 12'hA5A, 1'b1, 1'b1, 1'b0, 3'b101, 1'b1);
            SSEL = 1;
            #20;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            DO = 12'hC33;
            spi_transaction(16'h4000);


            #1;



            check_outputs(4'd0, 12'h000, 1'b1, 1'b1, 1'b1, 3'b010, 1'b0);
            SSEL = 1;
            #20;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            DO = 12'h000;
            spi_transaction(16'hFFFF);


            #1;



            check_outputs(4'd0, 12'hFFF, 1'b1, 1'b1, 1'b0, 3'b111, 1'b1);
            SSEL = 1;
            #20;
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            SSEL = 0;
            #10;
            for (i = 0; i < 8; i = i + 1) begin
                MOSI = 1;
                #10; SCK = 1; #10; SCK = 0;
            end



            #1;




            check_outputs(4'd8, DI, 1'b0, 1'b1, MISO, 3'b111, 1'b1);
            SSEL = 1;
            #20;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            DO = 12'h801;
            spi_transaction(16'h1000);

            #1;


            check_outputs(4'd0, 12'h000, 1'b1, 1'b1, 1'b1, 3'b000, 1'b1);
            SSEL = 1;
            #20;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SSPx_Slv Testbench");
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
        input [3:0] expected_BC;
        input [11:0] expected_DI;
        input expected_EOC;
        input expected_En;
        input expected_MISO;
        input [2:0] expected_RA;
        input expected_WnR;
        begin
            if (expected_BC === (expected_BC ^ BC ^ expected_BC) &&
                expected_DI === (expected_DI ^ DI ^ expected_DI) &&
                expected_EOC === (expected_EOC ^ EOC ^ expected_EOC) &&
                expected_En === (expected_En ^ En ^ expected_En) &&
                expected_MISO === (expected_MISO ^ MISO ^ expected_MISO) &&
                expected_RA === (expected_RA ^ RA ^ expected_RA) &&
                expected_WnR === (expected_WnR ^ WnR ^ expected_WnR)) begin
                $display("PASS");
                $display("  Outputs: BC=%h, DI=%h, EOC=%b, En=%b, MISO=%b, RA=%h, WnR=%b",
                         BC, DI, EOC, En, MISO, RA, WnR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BC=%h, DI=%h, EOC=%b, En=%b, MISO=%b, RA=%h, WnR=%b",
                         expected_BC, expected_DI, expected_EOC, expected_En, expected_MISO, expected_RA, expected_WnR);
                $display("  Got:      BC=%h, DI=%h, EOC=%b, En=%b, MISO=%b, RA=%h, WnR=%b",
                         BC, DI, EOC, En, MISO, RA, WnR);
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
        $dumpvars(0,DO, MOSI, Rst, SCK, SSEL, BC, DI, EOC, En, MISO, RA, WnR);
    end

endmodule
