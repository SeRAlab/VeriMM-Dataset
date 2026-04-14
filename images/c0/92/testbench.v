`timescale 1ns/1ps

module arbiter_node_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg [1:0] req;
    reg reset;
    wire [1:0] grant;
    wire select;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arbiter_node dut (
        .clock(clock),
        .enable(enable),
        .req(req),
        .reset(reset),
        .grant(grant),
        .select(select),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            reset = 1;
            enable = 0;
            req = 2'b00;
            @(posedge clock);
            reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: System Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Disabled Arbiter", test_num);
            reset_dut();
            enable = 0;
            req = 2'b11;
            @(posedge clock);

            #1;


            check_outputs(2'b00, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Request Channel 0", test_num);
            reset_dut();
            enable = 1;
            req = 2'b01;
            @(posedge clock);

            #1;


            check_outputs(2'b01, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Request Channel 1", test_num);
            reset_dut();
            enable = 1;
            req = 2'b10;
            @(posedge clock);

            #1;


            check_outputs(2'b10, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Request (Priority 0 wins)", test_num);
            reset_dut();
            enable = 1;
            req = 2'b11;

            @(posedge clock);

            #1;


            check_outputs(2'b01, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Arbitration (Round Robin)", test_num);
            reset_dut();
            enable = 1;


            req = 2'b01;
            @(posedge clock);



            req = 2'b11;
            @(posedge clock);


            #1;



            check_outputs(2'b10, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Persistence", test_num);
            reset_dut();
            enable = 1;
            req = 2'b00;
            @(posedge clock);
            @(posedge clock);

            #1;


            check_outputs(2'b00, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset during operation", test_num);
            reset_dut();
            enable = 1;
            req = 2'b11;
            @(posedge clock);

            reset = 1;
            @(posedge clock);

            #1;


            check_outputs(2'b00, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arbiter_node Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_grant;
        input expected_select;
        input expected_valid;
        begin
            if (expected_grant === (expected_grant ^ grant ^ expected_grant) &&
                expected_select === (expected_select ^ select ^ expected_select) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: grant=%h, select=%b, valid=%b",
                         grant, select, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%h, select=%b, valid=%b",
                         expected_grant, expected_select, expected_valid);
                $display("  Got:      grant=%h, select=%b, valid=%b",
                         grant, select, valid);
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
        $dumpvars(0,clock, enable, req, reset, grant, select, valid);
    end

endmodule
